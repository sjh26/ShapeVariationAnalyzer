clear all
close all
clc
addpath('./surfstat/')
Datapath='/Users/ninatubauribera/Desktop/groups/G06_07_20+5_Degeneration4/';

FileNames = dir(strcat(Datapath,'*.vtk'));

shape=cell(2,1);


for i = 1 : length(FileNames)
    
    [vertex,face] = read_vtk(strcat(Datapath,FileNames(i).name));
    X_coord = vertex(1,:)';
    Y_coord = vertex(2,:)';
    Z_coord = vertex(3,:)';
    
    %Surface = SurfStatReadSurf(strcat(Datapath,FileNames(i).name));
    %X = Surface.coord(1,:);
    shape{i}.X = X_coord;
    %Y = Surface.coord(2,:);
    shape{i}.Y = Y_coord;
    %Z = Surface.coord(3,:);
    shape{i}.Z = Z_coord;
    %TRIV = Surface.tri;
    %shape{i}.TRIV = double(TRIV);
    shape{i}.TRIV = double(face');
    Name = FileNames(i).name;
    shape{i}.name = Name(:,1:end-4);
    
    K = 100;            % number of eigenfunctions
    alpha = 2;          % log scalespace basis
    
    T1 = [5:0.5:16];    % time scales for HKS
    T2 = [1:0.2:20];    % time scales for SI-HKS
    Omega = 2:20;       % frequencies for SI-HKS
    
    % compute cotan Laplacian
    [shape{i}.W, shape{i}.A] = mshlp_matrix(shape{i});
    shape{i}.A = spdiags(shape{i}.A,0,size(shape{i}.A,1),size(shape{i}.A,1));
    
    % compute eigenvectors/values
    [shape{i}.evecs,shape{i}.evals] = eigs(shape{i}.W,shape{i}.A,K,'SM');
    shape{i}.evals = -diag(shape{i}.evals);
    
    % compute descriptors
    shape{i}.hks   = hks(shape{i}.evecs,shape{i}.evals,alpha.^T1);
    [shape{i}.sihks, shape{i}.schks] = sihks(shape{i}.evecs,shape{i}.evals,alpha,T2,Omega);
   

end


save(strcat(Datapath,'shapes.mat'),'shape')


%dataset=[shape{1}.X shape{1}.Y shape{1}.Z];
%[coeff,score,latent,tsquared,explained,mu]=pca(dataset);
%reconstruct=score*coeff'+repmat(mu,1002,1);

%diff=abs(shape{1,1}.sihks)-abs(shape{2,1}.sihks);

figure(1)
%subplot(121)
plot3(shape{1,1}.X,shape{1,1}.Y,shape{1,1}.Z,'.')
hold on;
%subplot(122)
%plot3(X_a,Y_a,Z_a,'.')
%plot3(reconstruct(:,1),reconstruct(:,2),reconstruct(:,3),'.')

% hold on;
% plot3(shape{2,1}.X,shape{2,1}.Y,shape{2,1}.Z,'.')
% plot3(shape{3,1}.X,shape{3,1}.Y,shape{3,1}.Z,'.')