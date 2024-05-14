function simulated_data = simulate_data_by_occlusion_vt_csv(params, dt, T, ntrials)
theta0= params(1);
theta1 = params(2)+params(1);

beltheta0= params(3);
beltheta1 = params(4)+params(3);

gamma = params(5);

minimal_ndt = params(6);
ndt_range = params(7);

alpha = params(8);
belalpha = params(9);

vt= params(10);
belvt = params(11);

softmax_temp = params(12);


symbols= min(1,[[theta0, theta1]*alpha.*(vt.^(-2:2))'; [theta0, theta1]/alpha.*(vt.^(-2:2))' ]);
symbols_bel= min(1,[[beltheta0,beltheta1]*belalpha.*(belvt.^(-2:2))'; [beltheta0,beltheta1]/belalpha.*(belvt.^(-2:2))']);

simulated_data = simulate_data_vt_csv(symbols,symbols_bel,gamma,minimal_ndt, ndt_range, softmax_temp, dt, T, ntrials);

end