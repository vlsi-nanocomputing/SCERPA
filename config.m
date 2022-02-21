function pathList = config(configVersion)

switch(configVersion)
    case char('internal')
        pathList.root2layout = fullfile("Layout");
        pathList.root2algorithm = fullfile("Algorithm");
        pathList.root2viewer = fullfile("Viewer");
        pathList.layout2root = fullfile("..");
        pathList.layout2database = fullfile("..","Database");
        pathList.algorithm2root = fullfile("..");
        pathList.algorithm2layoutData = fullfile("..","Layout","Data");
        pathList.algorithm2database = fullfile("..","Database");
        pathList.viewer2root = fullfile("..");
        
    case char('pubblication')
        pathList.root2layout = fullfile(".");
        pathList.root2algorithm = fullfile(".");
        pathList.root2viewer = fullfile(".");
        pathList.layout2root = fullfile(".");
        pathList.layout2database = fullfile(".");
        pathList.algorithm2root = fullfile(".");
        pathList.algorithm2layoutData = fullfile(".");
        pathList.algorithm2database = fullfile(".");
        pathList.viewer2root = fullfile(".");
end

end

