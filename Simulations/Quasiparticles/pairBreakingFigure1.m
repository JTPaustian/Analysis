function pairBreakingFigure1
%pairBreakingFigure1 Improved Figure 1 from J. M. Martinis et al.,
%Phys. Rev. Lett. 103, 097002 (2009). 

r = 2 * 1.7 * 1e-10 / (sqrt(8) - sqrt(2.8^2 - 1)); % in units of 1 / \tau_0
                                      %(assuming n_{qp} in units of n_{cp})
c = 0; % trapping rate in units of 1 / \tau_0
V = [2.8, 3.0]; % in units of \Delta
Tph = [0.140, 0.070, 0]; % K
tspan = [-100000, 0]; % in units of \tau_0

figure
hold on
n_qp_eq = nan(size(Tph));
ax = gca;
ax.ColorOrderIndex = 2; 
for k = 1:length(Tph)
    [~, e, ~, f, n_qp, ~, r_qp] = pairBreakingTrapping0DModel(r, c, V, Tph(k), tspan);
    n_qp_eq(k) = n_qp(end);
    plot(e, f(end, :), 'LineWidth', 3)
end

[~, e, ~, fT] = pairBreakingTrapping0DModel(0, c, V, Tph(1), tspan);
plot(e, fT(end, :), 'LineWidth', 3)

xlabel('Quasiparticle energy E/\Delta', 'FontSize', 14)
ylabel('State occupation f(E)', 'FontSize', 14)
title({['n_{qp} / 2D(E_F)\Delta = ', num2str(n_qp_eq(1)/2, '%.2e'),...
        '; r_{qp} = ', num2str(r_qp, '%.2e'), ' / \tau_0']})
legend({'T_p = 140 mK', '          70 mK', '            0',...
        'f_T [140 mK]'})
set(gca, 'yscale', 'Log')
axis([1 2.4 1e-12 1.01e-5])
grid on

end