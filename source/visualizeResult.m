%% visualizeResult.m
% Created by Michael Wild, Version 06.05.2026
% michael.wild@zhaw.ch
%
% Function to Visualize the irradiation Distribution on the panel.
%
%% Inputs
% 
% resultStruct  :   Output of runModel.m
% subname       :   string to be appended to savename
%
function [] = visualizeResult(resultStruct, subname)
arguments
    resultStruct (1,1) struct
    subname (1,:) char = ''
end


chi_vec = resultStruct.runInfo.chi_vec;
if ~exist(strcat('output/', resultStruct.runInfo.name))
    mkdir(strcat('output/', resultStruct.runInfo.name));
end
savename = strcat(resultStruct.runInfo.name, '_', subname);
f = figure();
Y_front = [resultStruct.irrad_fract_front_direct; resultStruct.irrad_fract_front_nearground_refl; resultStruct.irrad_fract_front_farground_refl];
Y_back = [resultStruct.irrad_fract_back_direct;resultStruct.irrad_fract_back_nearground_refl];
a_front = area(chi_vec, Y_front');
hold on
a_back = area(chi_vec, -Y_back');

a_front(1).FaceColor = '#AA3939';
a_back(1).FaceColor = '#D46A6A';
a_front(2).FaceColor = '#7A9F35';
a_back(2).FaceColor = '#A5C663';
a_front(3).FaceColor = '#226666';


view([-90 -90])
set(gca, 'XDir','reverse')
ylims = ylim();
ylim(1.1*ylims);


ylimspread = max(ylims)-min(ylims);
box on
grid on
axis square
%title(titlestr, "Interpreter", "Latex")

set(gcf,'units','centimeters','position',[5,5,16,9])
yticklabels(strsplit(num2str(abs(yticks))));

ylabel('Irradiation in Panel Plane [W/m$^2$]', 'Interpreter','Latex');
xlabel('Position $\chi$ on Panel [-]', 'Interpreter','Latex');

text(-0.1,ylimspread/20,'Frontside','Rotation',90,'Color','#222222','FontWeight','bold');
text(0.09,-ylimspread/20,'Backside','Rotation',-90,'Color','#222222','FontWeight','bold');
fontname("Times New Roman")


line([-0.5 0.5], [0 0],'LineStyle','--', 'Color','black');

legend({'Front Direct','Front Near-Ground Reflection','Front Far-Ground Reflection', 'Back Direct','Back Near-Ground Reflection'}, 'Location','eastoutside')

savestr = strcat('output/', resultStruct.runInfo.name,'/', savename, '.png');
print(gcf, savestr, '-dpng','-r300' );

annot_str = {strcat('$\mu = $', num2str(resultStruct.runInfo.mu_deg), "$^{\circ}$"), strcat('$\gamma = $', num2str(resultStruct.runInfo.gamma_deg), "$^{\circ}$"), strcat('$\overline{\rho} = $', num2str(resultStruct.runInfo.rho_bar,3)), strcat('$\overline{h} = $', num2str(resultStruct.runInfo.h_bar)),strcat('$\alpha_g = $', num2str(resultStruct.runInfo.alpha_g_deg), "$^{\circ}$")};
annot_str_2 = {strcat('DNI = ', num2str(resultStruct.runInfo.DNI,4), " $W/m^2$"),strcat('GHI = ', num2str(resultStruct.runInfo.GHI,4), " $W/m^2$"), strcat('$\alpha_s = $', num2str(resultStruct.runInfo.sunposition.azimuth*180/pi,2), "$^{\circ}$"), strcat('$\sigma_s = $', num2str(90-(resultStruct.runInfo.sunposition.zenith)*180/pi,3), "$^{\circ}$")};

annotation('textbox',[0.61 0.12 0.11 0.3], 'String',annot_str, 'Interpreter','Latex');
annotation('textbox',[0.74 0.12 0.2 0.3], 'String',annot_str_2, 'Interpreter','Latex');
legend({'Front Direct','Front Near-Ground Reflection','Front Far-Ground Reflection', 'Back Direct','Back Near-Ground Reflection'}, 'Location','northeastoutside')

savestr_2 = strcat('output/', resultStruct.runInfo.name,'/', savename, '_annot.png');
print(gcf, savestr_2, '-dpng','-r300');

close(f);

end