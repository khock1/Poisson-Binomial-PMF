% Probability mass function of Poisson Binomial distribution with recursive approach
% Author: Karlo Hock, University of Queensland. 2018

% Calculate probabilities of obtaining k successful trials in a series of n 
% independent Bernoulli trials with different probabilities of success;
% in the example below, there are five trials (n=5), and the first trial has a success 
% chance of 0.25, etc. Alternatively, the example probabilties can be replaced 
% by a RNG that gives individual probabilities; since the trials are
% independent, the individual probabilities need not add up to 1

% probabilities of success in individual Bernoulli trials; values used as a demonstration example
success_probabilities = [0.25 0.15 0.05 0.1 0.8];

% number of trials
n_trials = length(success_probabilities);

% container for storing results on k number of successes
num_successes = struct('k', [], 'prob_k_successes', []);

% calculate the chance of obtaining any number of successes (up to n_trials)
for k = 1:n_trials
    this_k = nchoosek(1:n_trials, k);% list all combinations of having k number of successes
    this_cmlprob = 0;% storing the cumulative probability of k sucesses
    % now determine the probability of obtaining each combination of
    % k successes given the success probabilities inindividual trials
    for cmb = 1:size(this_k, 1)
        this_comb = this_k(cmb, :);% pick a possible combination of trials that gives k successes
        % we now need to calculate the cumulative probability of getting successes 
        % in all k trials, which is a product of probabilties of succeeding
        % or failing in each trial
        this_prod = 1;
        for i = 1:n_trials
            % if this trial is a success in this combination, use its success probability
            if ismember(i, this_comb)
                this_prod = this_prod * success_probabilities(i);
            else% else if this trial is a failure, use its probability of failure
                this_prod = this_prod * (1 - success_probabilities(i));
            end
        end
        % add the probabilty of obtaining this combination of k success to
        % the cumulative probability of obtaining k successes
        this_cmlprob = this_cmlprob + this_prod;
    end
    % store values
    num_successes(k+1).k = k;
    num_successes(k+1).prob_k_successes = this_cmlprob;
end
% add an additional category for all fails/zero successes
num_successes(1).k = 0;
% determine the chance of obtaining k=0 successes by subtracting the sum of all other probabilities from 1;
% unlike the probabilities of success in individual trials, all probabilities of obtaining 
% exactly k successes do need to add up to 1 , i.e., sum = 1 for all k when k = [0,..,n]
num_successes(1).prob_k_successes = 1 - sum([num_successes(2:end).prob_k_successes]);

% num_sucesses structure answers the question "what is the probability of
% obtaining exactly k sucesses given the independent success probabilities in 
% individual trials/events?"

% finally, check that it all really adds up to 1
total_cmlprobability = sum([num_successes.prob_k_successes]);
