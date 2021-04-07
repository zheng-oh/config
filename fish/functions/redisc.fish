# Defined in - @ line 1
function redisc --wraps='docker exec -it redis redis-cli' --description 'alias redisc=docker exec -it redis redis-cli'
  docker exec -it redis redis-cli $argv;
end
