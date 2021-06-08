classdef Agent < handle
    %AGENT Class of agents in the swarm
    %   ... TODO DESCRIBE SYSTEM... explain logic
    %   ... TODO generalize for 3D
    
    properties
        position = zeros(2,1);
%         velocity = 0;
        orientation = zeros(1,1);
        continuousTime = false;
        t = 0;
    end
    
    methods
        function agent = Agent(x0, phi0, t0, continuousTime)
            %AGENT Construct an instance of this class
            %   INPUT:
            %       x0      -- initial position
            %       [TODO] v0      -- initial velocity
            %       phi0    -- initial orientation
            %       t0      -- initial time
            %       continuousTime -- dynamics is continuous time
            %   OUTPUT:
            %       agent   -- agent instance
            arguments
                x0              (2,1)
%                 v0              (1,1)
                phi0            (1,1)
                t0              (1,1)
                continuousTime  logical = false
            end
            
            agent.position = x0;
%             agent.velocity = v0;
            agent.orientation = phi0;
            agent.t = t0;
            agent.continuousTime = continuousTime;
        end
        
        function tick(agent,target,T)
            %TICK Summary of this method goes here
            %   Detailed explanation goes here
            %
            
            arguments 
                agent           Agent
                target          (2,1)
                T               (1,1)
            end
            [~, ubar] = agent.llc(target);
            if agent.continuousTime
                agent.evolve(ubar, agent.t + [0, T]);
            else
                agent.step(ubar, T);
            end
            agent.t = T + agent.t;
        end
        
        function evolve(agent,ubar,timespan)
            [~, y] = ode45(...
                @(t, y) agent.dynamics(y(3), ubar(1), ubar(2)), ...
                timespan, ...
                [agent.position; agent.orientation]);
            
            agent.position = y(end, 1:2).';
            agent.orientation = y(end, 3);
        end
        
        function dxdt = dynamics(agent, phi, vel, angVel)
            [nx, nphi] = agent.noisyDynamics;%([vel; angVel]);
            
            ori = [cos(phi(1)); sin(phi(1))];
            dxdt = [...
                vel * ori + nx;
                angVel + nphi];
        end
        
        function step(agent,ubar,Ts)
            % STEP performs one step of the state update map
            %   INPUT:
            %       ubar    -- input applied to the system
            %       Ts      -- sampling time
            %   Euler discretization of the system. Override to implement a
            %   different discrete time system.
            
            dxdt = agent.dynamics(agent.orientation, ubar(1), ubar(2));
            agent.position = agent.position + Ts * dxdt(1:2);
            agent.orientation = agent.orientation + Ts * dxdt(3);
        end
        
        function [nx, nphi] = noisyDynamics(agent, ubar)
            % NOISYDYNAMICS implements the noise affecting the dynamics
            %   INPUT:
            %       ubar    -- input applied to the system
            %   OUTPUT:
            %       nx      -- position dynamics noise 
            %       [TODO] nv      -- velocity dynamics noise
            %       nphi    -- orientation dynamics noise
            
            nx = zeros(size(agent.position));
%             nv = zeros(size(agent.velocity));
            nphi = zeros(size(agent.orientation));
        end
        
        function [u, ubar] = llc(agent, target)
            % LLC implements the low level controller of the agent
            %   INPUT:
            %       target  -- reference position to reach
            %   OUTPUT:
            %       u       -- desired input to reach the target
            %       ubar    -- input effectively applied to the system
            %   
            %   Override this method to implement a different llc
            arguments
                agent   Agent
                target  (2,1)
            end
            
            u = zeros(2,1);
            delta = target - agent.position;
            if any(delta ~= 0)
                theta = agent.orientation(1) - atan2(delta(2), delta(1));
                u(1) = .1 * norm(delta) * cos(theta);
                u(2) = -.1 * theta;% -.2 *cos(theta)*sin(theta);
            end
            
            ubar = agent.actuate(u);
        end
        
        function ubar = actuate(agent, u)
            % ACTUATE provides the output effectively applied to the agent
            %   INPUT:
            %       u       -- desired input
            %       env     -- environment the agent is moving in
            %   OUTPUT:
            %       ubar    -- input applied
            %   
            %   Override this method to implement actuator limitations
            
%             ubar = u; % default: none
            ubar(1) = max(-.1, min(.1, u(1)));
%             ubar(2) = max(-.5, min(.5, u(2)));
            ubar(2) = u(2);
        end
    end
end

