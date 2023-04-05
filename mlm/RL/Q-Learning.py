#Ref: https://www.edureka.co/blog/q-learning/
import numpy as np
 
gamma = 0.75 # Discount factor
alpha = 0.9 # Learning rate
 
location_to_state = {
    'L1' : 0,
    'L2' : 1,
    'L3' : 2,
    'L4' : 3,
    'L5' : 4,
    'L6' : 5,
    'L7' : 6,
    'L8' : 7,
    'L9' : 8
}
 
rewards = np.array([[0,1,0,1,0,0,0,0,0],
              [1,0,1,0,1,0,0,0,0],
              [0,1,0,0,0,1,0,0,0],
              [1,0,0,0,0,0,1,0,0],
              [0,1,0,0,0,0,0,1,0],
              [0,0,1,0,0,0,0,0,0],
              [0,0,0,1,0,0,0,1,0],
              [0,0,0,0,1,0,1,0,1],
              [0,0,0,0,0,0,0,1,0]])

state_to_location = dict((state,location) for location,state in location_to_state.items())

def get_optimal_route(start_location,end_location):
    rewards_new = np.copy(rewards)
    ending_state = location_to_state[end_location]
    rewards_new[ending_state,ending_state] = 999
 
    Q = np.array(np.zeros([9,9]))
 
    # Q-Learning process (list them up!)
    for i in range(1000):
        # Picking up a random state
        current_state = np.random.randint(0,9) # Python excludes the upper bound
        playable_actions = []
        # Iterating through the new rewards matrix
        for j in range(9):
            if rewards_new[current_state,j] > 0:
                playable_actions.append(j)
        # Pick a random action that will lead us to next state
        next_state = np.random.choice(playable_actions)
        # Computing Temporal Difference
        TD = rewards_new[current_state,next_state] + gamma * Q[next_state, np.argmax(Q[next_state,])] - Q[current_state,next_state]
        # Updating the Q-Value using the Bellman equation
        Q[current_state,next_state] += alpha * TD
 
    # Initialize the optimal route with the starting location
    route = [start_location]
    #Initialize next_location with starting location
    next_location = start_location
 
    # We don't know about the exact number of iterations needed to reach to the final location hence while loop will be a good choice for iteratiing
    while(next_location != end_location):
        # Fetch the starting state
        starting_state = location_to_state[start_location]
        # Fetch the highest Q-value pertaining to starting state
        next_state = np.argmax(Q[starting_state,])
        # We got the index of the next state. But we need the corresponding letter.
        next_location = state_to_location[next_state]
        # add this due to "Memory Error"
        if next_location in route:
            Q[starting_state][next_state]=0
            next_state = np.argmax(Q[starting_state,])
            next_location = state_to_location[next_state]
            route.append(next_location)
            start_location = next_location
        route.append(next_location)
        # Update the starting location for the next iteration
        start_location = next_location
 
    return route

print(get_optimal_route('L4', 'L9'))
