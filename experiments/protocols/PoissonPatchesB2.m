function [mazes, criteria, globalSettings, vr] = PoissonPatchesB2(vr)

  %__________________________________________ 1 _________ 2 _________ 3 _________ 4 _________ 5 _________ 6 _________ 7 _________ 8 _________ 9 _________ 10 _________ 11 ______ 12 __________ 13 ________________
  mazes     = struct( 'lStart'            , {5         , 30        , 30        , 30        , 30        , 30        , 30        , 30        , 30         , 30         , 30         , 30         , 30         }   ...
                    , 'lCue'              , {40        , 100       , 180       , 280       , 380       , 380       , 360       , 360       , 350        , 350        , 300        , 250        , 250        }   ...
                    , 'lMemory'           , {10        , 10        , 20        , 20        , 20        , 20        , 40        , 40        , 50         , 50         , 100        , 150        , 150        }   ...
                    , 'tri_turnHint'      , {inf       , inf       , 120       , 170       , 200       , false     , false     , false     , false      , false      , false      , false      , false      }   ... % cm before interesection
                    , 'hHint'             , {60        , 60        , 60        , 60        , 60        , 25        , 25        , 25        , 25         , 25         , 25         , 25         , 25         }   ...
                    , 'cueVisibleAt'      , {inf       , inf       , inf       , inf       , inf       , inf        , 16        , 12        , 8          , 6          , 6          , 6          , 6          }   ... cm
                    , 'cueDuration'       , {nan       , nan       , nan       , nan       , nan       , nan       , nan       , nan       , inf        , 0.2        , 0.2        , 0.2        , 0.2        }   ... seconds
                    , 'cueProbability'    , {inf       , inf       , inf       , inf       , inf       , inf       , 2.5       , 1.2       , 1.2        , 1.2        , 1.2        , 1.2        , 1.2        }   ...
                    , 'cueDensityPerM'    , {1         , 2.5       , 2.5       , 2.5       , 2.5       , 2.5       , 3         , 3.5       , 3.5        , 3.5        , 3.5        , 3.5        , 3.5        }   ...
                    , 'DecisionZoneStart' , {0         , 50        , 80        , 130       , 150       , 150       , 150       , 150       , 150        , 150 	     , 100        , 50         , 0          }   ...
                    );                                                                                                                                                                       
  criteria  = struct( 'numTrials'         , {20        , 80        , 100       , 100       , 100       , 100       , 100       , 100       , 100        , 100        , 100        , 100        , 100        }   ...
                    , 'numTrialsPerMin'   , {3         , 3         , 3         , 3         , 3         , 3         , 3         , 3         , 3          , 3          , 3          , 3          , 3          }   ...
                    , 'warmupNTrials'     , {[]        , []        , []        , []        , []        , 40        , 40        , 40        , [10  ,15  ], [10  ,15  ], [10  ,15 ] , [10  ,15  ], [10  ,15  ]}   ...
                    , 'numSessions'       , {0         , 0         , 0         , 0         , 2         , 2         , 1         , 3         , 1          , 2          , 1          , 1          , 1          }   ...
                    , 'performance'       , {0         , 0         , 0.6       , 0.6       , 0.8       , 0.8       , 0.75      , 0.7       , 0.7        , 0.65       , 0.65       , 0.65       , 0.65      }   ...
                    , 'maxBias'           , {inf       , 0.2       , 0.2       , 0.2       , 0.1       , 0.1       , 0.15      , 0.15      , 0.15       , 0.15       , 0.15       , 0.15       , 0.15       }   ...
                    , 'warmupMaze'        , {[]        , []        , []        , []        , []        , 5         , [5, 6]    , [5, 7]    , [5   ,7   ], [5   ,7   ], [5   ,7   ], [5   ,7   ], [5   ,7   ]}   ...
                    , 'warmupPerform'     , {[]        , []        , []        , []        , []        , 0.8       ,[0.85,0.8] ,[0.85,0.75],[0.85,0.75 ],[0.85,0.75 ],[0.85,0.75] ,[0.85,0.75 ],[0.85,0.75 ]}   ...
                    , 'warmupBias'        , {[]        , []        , []        , []        , []        , 0.1       ,[0.1,0.1]  , [0.1,0.1] , [0.1 ,0.1 ], [0.1 ,0.1 ], [0.1 ,0.1 ], [0.1 ,0.1 ], [0.1 ,0.1 ]}   ...
                    , 'warmupMotor'       , {[]        , []        , []        , []        , []        , 0         ,[0.75,0.75],[0.75,0.75], [0.75,0.75], [0.75,0.75], [0.75,0.75], [0.75,0.75], [0.75,0.75]}   ...
                    );

  globalSettings          = {'cueMinSeparation', 16, 'yCue', 8};
  vr.numMazesInProtocol   = numel(mazes);
  vr.stimulusGenerator    = @PoissonStimulusTrain_decisionZone;
  vr.stimulusParameters   = {'cueVisibleAt', 'cueDensityPerM', 'cueProbability', 'nCueSlots', 'cueMinSeparation', 'panSessionTrials','DecisionZoneStart'};
  vr.inheritedVariables   = {'lCue','lMemory','cueDuration','DecisionZoneStart'};

  
  if nargout < 1
    figure; plot([mazes.lStart] + [mazes.lCue] + [mazes.lMemory], 'linewidth',1.5); xlabel('Shaping step'); ylabel('Maze length (cm)'); grid on;
    hold on; plot([mazes.lMemory], 'linewidth',1.5); legend({'total', 'memory'}, 'Location', 'east'); grid on;
    figure; plot([mazes.lMemory] ./ [mazes.lCue], 'linewidth',1.5); xlabel('Shaping step'); ylabel('L(memory) / L(cue)'); grid on;
    figure; plot([mazes.cueDensityPerM], 'linewidth',1.5); set(gca,'ylim',[0 6.5]); xlabel('Shaping step'); ylabel('Tower density (count/m)'); grid on;
    hold on; plot([mazes.cueDensityPerM] .* (1 - 1./(1 + exp([mazes.cueProbability]))), 'linewidth',1.5);
    hold on; plot([1 numel(mazes)], [1 1].*(100/globalSettings{2}), 'linewidth',1.5, 'linestyle','--');
    legend({'\rho_{L} + \rho_{R}', '\rho_{salient}', '(maximum)'}, 'location', 'southeast');
  end

end
