function children = MutateBinary(children, mutationRate)
    mutationMatrix = rand(size(children)) < mutationRate;
    children = xor(children, mutationMatrix);
end
