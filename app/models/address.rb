# so that code that uses Address (like in app/decorators/models/fe/person_common_engine_decorator.rb) still works
class Address < Fe::Address
end
