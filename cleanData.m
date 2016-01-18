function anData = cleanData(anData)

variables = fieldnames(anData);

for cnt = 1:numel(variables)
    if  ~isreal(anData.(variables{cnt})) && ~strcmp(variables{cnt}, 'Parameter')  && ~strcmp(variables{cnt}, 'sample')...
            && ~strcmp(variables{cnt}, 'water') &&  ~strcmp(variables{cnt}, 'ice')...
            && ~strcmp(variables{cnt}, 'artefact') && ~strcmp(variables{cnt}, 'meteoInt') ...
            && ~strcmp(variables{cnt}, 'indUpdraft') && ~iscategorical(anData.(variables{cnt}))
        anData.(variables{cnt}) = real(anData.(variables{cnt}));
    end
end