% main function to concatenate and compare different pulse design methods
% such as SVDS, CVDS, even VERSE and solvers for Ax=b

% the pulse design procedure has been divided into:
%     1) target excitation profile generation;
%     2) k-space traversal trajectory generation;
%     3) solve Ax = b with small or large tip angle
%     4) write pulses to txt files
%     5) bloch simulation 

% author : Qing Li, Zhejiang University
% date : Feb. 19, 2017

% This demo code has taken advantages of some open source matlab code from the authors
% including: Dr. Grissom; Dr. Fessler; Dr. Lustig; 

%% 
addPath;

alpha = 10;
Beta = 0.2;

currLoc = pwd;

% initialize pulsePara
pulsePara = setup_pulsePara(currLoc);


% 1) excitation profile
% M1 : self_rect;
% M2 : predef_rect;circle
method = 'circle'; % go to the method directly to change the parameters M1: predef_rect
% method = 'input'; % go to the method directly to change the parameters
% pulsePara.d = d;  
% pulsePara.shapeIdx = shapeIdx;
pulsePara = tarGen(pulsePara, method);

pulsePara.ssqueeze.alpha = alpha;

% 2) k-space trajectory
method = 'SVDS'; % '2Dspiral\...keep adding' 
pulsePara.beta = Beta; %  
pulsePara = kGen(pulsePara, method);


% 3) RF pulse design
method = 'STA'; % 'STA \ LTA ' 
pulsePara.niter = 100;
pulsePara = rfGen(pulsePara, method);


% 3.5) VERSE process
verseFactor = 0.6;  % control the VERSE performance
VERSE_ON = 0;
if VERSE_ON == 1
   pulsePara = verseOn(pulsePara,verseFactor); 
   pulsePara.beta = Beta;
   pulsePara = rfGen(pulsePara, method);
end

       
% 4) write the pulse to txt
pulsePara = txtGen(pulsePara);
t = toc;

% 5) run the Bloch simulation
cd(currLoc);
SimBloch4(pulsePara);

