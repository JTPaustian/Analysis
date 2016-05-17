function twoStageFit2TrapNoTrap
%twoStageFit2TrapNoTrap Fitting to TrapNoTrap dataset.

% r_direct_no_tr = 1.471e-05; % in units of 1 / \tau_0 %(assuming n_{qp} in units of n_{cp})
% r_phonon_no_tr = 4.876e-02; % in units of 1 / \tau_0 %(assuming n_{qp} in units of n_{cp})
% c_no_tr = 1.603e-02; % trapping rate in units of 1 / \tau_0
% vol_no_tr = 3.044e+04; % um^3
r_direct_no_tr = 7.917e-05; r_phonon_no_tr = 6.061e-03; c_no_tr = 1.848e-02; vol_no_tr = 5.000e+03; 

% r_direct_tr = 4.875e-06; % in units of 1 / \tau_0 %(assuming n_{qp} in units of n_{cp})
% r_phonon_tr = 1.138e-02; % in units of 1 / \tau_0 %(assuming n_{qp} in units of n_{cp})
% c_tr = 1.591e-02; % trapping rate in units of 1 / \tau_0
% vol_tr = 2.585e+05; % um^3
r_direct_tr = 1.649e-04; r_phonon_tr = 8.646e-05; c_tr = 1.021e-02; vol_tr = 5.000e+03; 

delta = 0.18e-3; % eV (aluminum superconducting gap)
Tph = 0.051; % K
tspan = [-300, 0]; % in units of \tau_0

% Number of the energy bins.
N = 500;

data = load('TrapNoTrap.mat');

V_tr = data.Trap(:, 5) / delta;
P_tr = data.Trap(:, 6);
nqp_tr = data.Trap(:, 8) - min(data.Trap(:, 8));

V_no_tr = data.NoTrap(:, 5) / delta;
P_no_tr = data.NoTrap(:, 6);
nqp_no_tr = data.NoTrap(:, 8) - min(data.NoTrap(:, 8));

figure
loglog(V_no_tr, nqp_no_tr, 'bo', V_tr, nqp_tr, 'ko', ...
    'MarkerSize', 10, 'LineWidth', 2)
xlabel('Injection Energy (\Delta)', 'FontSize', 14)
ylabel('Quasiparticle Density (\mu m^{-3})', 'FontSize', 14)
legend('no traps', 'with traps', 'Location', 'SouthEast')
title('Experiment')
axis tight
grid on

figure
loglog(P_no_tr, nqp_no_tr, 'bo', P_tr, nqp_tr, 'ko', ...
    'MarkerSize', 10, 'LineWidth', 2)
xlabel('Injection Power (W)', 'FontSize', 14)
ylabel('Quasiparticle Density (\mu m^{-3})', 'FontSize', 14)
legend('no traps', 'with traps', 'Location', 'SouthEast')
title('Experiment')
axis tight
grid on

nqp_sim_no_tr = NaN(size(V_no_tr));
nqp_sim_tr = NaN(size(V_tr));
P_sim_no_tr = NaN(size(V_no_tr));
P_sim_tr = NaN(size(V_tr));
for k = 1:length(V_no_tr)
    if V_no_tr(k) > 1
        [~, ~, ~, ~, nqp, ~, P_sim_no_tr(k)] = twoStageQuasi0DModel(Tph, tspan,...
            V_no_tr(k), r_direct_no_tr, r_phonon_no_tr, c_no_tr, vol_no_tr, N, false);
        nqp_sim_no_tr(k) = max(nqp);
    else
        nqp_sim_no_tr(k) = 0;
    end
    k
end
for k = 1:length(V_tr)
    if V_tr(k) > 1
        [~, ~, ~, ~, nqp, ~, P_sim_tr(k)] = twoStageQuasi0DModel(Tph, tspan,...
            V_tr(k), r_direct_tr, r_phonon_tr, c_tr, vol_tr, N, false);
        nqp_sim_tr(k) = max(nqp);
    else
        nqp_sim_tr(k) = 0;
    end
    k
end

scrsz = get(0, 'ScreenSize');
figure('Position', [.1 .1 1.5 .8] * scrsz(4));
subplot(1, 2, 1)
loglog(V_no_tr, nqp_no_tr, 'bo', V_no_tr, nqp_sim_no_tr, 'm*',...
    'MarkerSize', 10, 'LineWidth', 2)
xlabel('Injection Energy (\Delta)', 'FontSize', 14)
ylabel('Quasiparticle Density (\mu m^{-3})', 'FontSize', 14)
legend({'no trap, experiment', ['simulation: ',...
    'r_{qp} = ', num2str(r_direct_no_tr, '%.2e'), ', ',...
    'r_{ph} = ', num2str(r_phonon_no_tr, '%.2e'), ', ',...
    'c_{trap} = ', num2str(c_no_tr, '%.2e')]},...
    'Location', 'SouthEast')
title('No Traps')
axis tight
grid on
 
subplot(1, 2, 2)
loglog(V_tr, nqp_tr, 'ko', V_tr, nqp_sim_tr, 'm*',...
    'MarkerSize', 10, 'LineWidth', 2)
xlabel('Injection Energy (\Delta)', 'FontSize', 14)
ylabel('Quasiparticle Density (\mu m^{-3})', 'FontSize', 14)
legend({'experiment', ['simulation: ',...
    'r_{qp} = ', num2str(r_direct_tr, '%.2e'), ', ',...
    'r_{ph} = ', num2str(r_phonon_tr, '%.2e'), ', ',...
    'c_{trap} = ', num2str(c_tr, '%.2e')]},...
    'Location', 'SouthEast')
title('With Traps')
axis tight
grid on

scrsz = get(0, 'ScreenSize');
figure('Position', [.1 .1 1.5 .8] * scrsz(4));
subplot(1, 2, 1)
loglog(P_no_tr, nqp_no_tr, 'bo', P_sim_no_tr, nqp_sim_no_tr, 'm*',...
    'MarkerSize', 10, 'LineWidth', 2)
xlabel('Injection Power (W)', 'FontSize', 14)
ylabel('Quasiparticle Density (\mu m^{-3})', 'FontSize', 14)
legend({'no trap, experiment', ['simulation: ',...
    'r_{qp} = ', num2str(r_direct_no_tr, '%.2e'), ', ',...
    'r_{ph} = ', num2str(r_phonon_no_tr, '%.2e'), ', ',...
    'c_{trap} = ', num2str(c_no_tr, '%.2e')]},...
    'Location', 'SouthEast')
title('No Traps')
axis tight
grid on
 
subplot(1, 2, 2)
loglog(P_tr, nqp_tr, 'ko', P_sim_tr, nqp_sim_tr, 'm*',...
    'MarkerSize', 10, 'LineWidth', 2)
xlabel('Injection Power (W)', 'FontSize', 14)
ylabel('Quasiparticle Density (\mu m^{-3})', 'FontSize', 14)
legend({'experiment', ['simulation: ',...
    'r_{qp} = ', num2str(r_direct_tr, '%.2e'), ', ',...
    'r_{ph} = ', num2str(r_phonon_tr, '%.2e'), ', ',...
    'c_{trap} = ', num2str(c_tr, '%.2e')]},...
    'Location', 'SouthEast')
title('With Traps')
axis tight
grid on

end