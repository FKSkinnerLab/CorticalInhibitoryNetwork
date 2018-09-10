close all
%%
figure('units','normalized','position',[0 0 1 1])

plot(x_exp_control(11:23), control_exp_initial(11:23), 'ro-', 'LineWidth', 2)
hold on
% plot(x_exp_control(11:23), control_exp_initial(11:23), 'r-', 'LineWidth', 2)
% hold on
% plot(x_model(1:101), control_model(1:101), 'b-', 'LineWidth', 2)
% hold on
plot(x_exp_control(11:23), control_exp_final(11:23), 'mo-', 'LineWidth', 2)
hold on
% plot(x_exp_control(17:23), control_exp_final(17:23), 'm-', 'LineWidth', 2)
% hold on
% plot(x_model(1:101), control_model_final(1:101), 'c-', 'LineWidth', 2)

axis([0 100 0 20])

set(gca, 'FontSize', 20);
xlabel('Input Current (pA)', 'FontSize', 26);
ylabel('Firing Frequency (Hz)', 'FontSize', 26);

lgd=legend('Control, Experiment (Using Initial ISI)', 'Control, Experiment (Using Final ISI)', 'Location', 'NorthWest');
lgd.FontSize=20;

str1=sprintf('FI_control_exp_2.png');
str2=sprintf('FI_control_exp_2.fig');
saveas(gcf, str2)
set(gcf,'PaperPositionMode','auto')
print(str1, '-dpng', '-r0');

%%
figure('units','normalized','position',[0 0 1 1])

% plot(x_exp_control(11:23), control_exp_initial(11:23), 'r-o', 'LineWidth', 2)
% hold on
plot(x_model(1:101), control_model(1:101), 'b-', 'LineWidth', 2)
hold on
% plot(x_exp_control(11:23), control_exp_final(11:23), 'm-o', 'LineWidth', 2)
% hold on
plot(x_model(1:101), control_model_final(1:101), 'c-', 'LineWidth', 2)
hold on

axis([0 100 0 65])

set(gca, 'FontSize', 20);
xlabel('Input Current (pA)', 'FontSize', 26);
ylabel('Firing Frequency (Hz)', 'FontSize', 26);

lgd=legend('Control, Model (Using Initial ISI)', 'Control, Model (Using Final ISI)', 'Location', 'NorthWest');
lgd.FontSize=20;

str1=sprintf('FI_control_model.png');
str2=sprintf('FI_control_model.fig');
saveas(gcf, str2)
set(gcf,'PaperPositionMode','auto')
print(str1, '-dpng', '-r0');

%%
figure('units','normalized','position',[0 0 1 1])

plot(x_exp_fourap(11:end-1), fourap_exp_initial(11:end-1), 'ro-', 'LineWidth', 2)
hold on
% plot(x_exp_fourap(11:end-1), fourap_exp_initial(11:end-1), 'r-', 'LineWidth', 2)
% hold on
% plot(x_model(1:101), fourap_model(1:101), 'b-', 'LineWidth', 2)
% hold on
plot(x_exp_fourap(11:end-1), fourap_exp_final(11:end-1), 'mo-', 'LineWidth', 2)
hold on
% plot(x_exp_fourap(11:end-1), fourap_exp_final(11:end-1), 'm-', 'LineWidth', 2)
% hold on
% plot(x_model(1:101), fourap_model_final(1:101), 'c-', 'LineWidth', 2)
% hold on

axis([0 100 0 20])

set(gca, 'FontSize', 20);
xlabel('Input Current (pA)', 'FontSize', 26);
ylabel('Firing Frequency (Hz)', 'FontSize', 26);

lgd=legend('4-AP, Experiment (Using Initial ISI)', '4-AP, Experiment (Using Final ISI)', 'Location', 'NorthWest');
lgd.FontSize=20;

str1=sprintf('FI_4AP_exp_2.png');
str2=sprintf('FI_4AP_exp_2.fig');
saveas(gcf, str2)
set(gcf,'PaperPositionMode','auto')
print(str1, '-dpng', '-r0');

%%
figure('units','normalized','position',[0 0 1 1])

% plot(x_exp_fourap(11:end-1), fourap_exp_initial(11:end-1), 'r-o', 'LineWidth', 2)
% hold on
plot(x_model(1:101), fourap_model(1:101), 'b-', 'LineWidth', 2)
hold on
% plot(x_exp_fourap(11:end-1), fourap_exp_final(11:end-1), 'm-o', 'LineWidth', 2)
% hold on
plot(x_model(1:101), fourap_model_final(1:101), 'c-', 'LineWidth', 2)
hold on

axis([0 100 0 65])

set(gca, 'FontSize', 20);
xlabel('Input Current (pA)', 'FontSize', 26);
ylabel('Firing Frequency (Hz)', 'FontSize', 26);

lgd=legend('4-AP, Model (Using Initial ISI)', '4-AP, Model (Using Final ISI)', 'Location', 'NorthWest');
lgd.FontSize=20;

str1=sprintf('FI_4AP_model.png');
str2=sprintf('FI_4AP_model.fig');
saveas(gcf, str2)
set(gcf,'PaperPositionMode','auto')
print(str1, '-dpng', '-r0');