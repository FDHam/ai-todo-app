require 'rails_helper'

RSpec.describe Todo, type: :model do
  describe 'validations' do
    subject { build(:todo) }

    it { should validate_presence_of(:title) }
    it { should validate_length_of(:title).is_at_least(3).is_at_most(100) }
    it { should validate_length_of(:description).is_at_most(500) }
    it { should validate_inclusion_of(:completed).in_array([ true, false ]) }

    describe 'title validation' do
      it 'is valid with a title of minimum length' do
        todo = build(:todo, title: 'Buy')
        expect(todo).to be_valid
      end

      it 'is invalid with a title shorter than 3 characters' do
        todo = build(:todo, title: 'Hi')
        expect(todo).not_to be_valid
        expect(todo.errors[:title]).to include('is too short (minimum is 3 characters)')
      end

      it 'is invalid with a title longer than 100 characters' do
        todo = build(:todo, title: 'A' * 101)
        expect(todo).not_to be_valid
        expect(todo.errors[:title]).to include('is too long (maximum is 100 characters)')
      end

      it 'is valid with a title at maximum length' do
        todo = build(:todo, title: 'A' * 100)
        expect(todo).to be_valid
      end

      it 'is invalid with blank title' do
        todo = build(:todo, title: '')
        expect(todo).not_to be_valid
        expect(todo.errors[:title]).to include("can't be blank")
      end

      it 'is invalid with nil title' do
        todo = build(:todo, title: nil)
        expect(todo).not_to be_valid
        expect(todo.errors[:title]).to include("can't be blank")
      end
    end

    describe 'description validation' do
      it 'is valid with no description' do
        todo = build(:todo, description: nil)
        expect(todo).to be_valid
      end

      it 'is valid with empty description' do
        todo = build(:todo, description: '')
        expect(todo).to be_valid
      end

      it 'is valid with description at maximum length' do
        todo = build(:todo, description: 'A' * 500)
        expect(todo).to be_valid
      end

      it 'is invalid with description longer than 500 characters' do
        todo = build(:todo, description: 'A' * 501)
        expect(todo).not_to be_valid
        expect(todo.errors[:description]).to include('is too long (maximum is 500 characters)')
      end
    end

    describe 'completed validation' do
      it 'is valid when completed is true' do
        todo = build(:todo, completed: true)
        expect(todo).to be_valid
      end

      it 'is valid when completed is false' do
        todo = build(:todo, completed: false)
        expect(todo).to be_valid
      end
    end
  end

  describe 'default values' do
    it 'defaults completed to false' do
      todo = Todo.new(title: 'Test todo')
      expect(todo.completed).to be false
    end
  end

  describe 'scopes' do
    let!(:completed_todo) { create(:completed_todo) }
    let!(:pending_todo) { create(:todo) }
    let!(:older_todo) { create(:todo, created_at: 1.day.ago) }

    describe '.completed' do
      it 'returns only completed todos' do
        expect(Todo.completed).to eq([ completed_todo ])
      end
    end

    describe '.pending' do
      it 'returns only pending todos' do
        expect(Todo.pending).to match_array([ pending_todo, older_todo ])
      end
    end

    describe '.recent' do
      it 'returns todos ordered by created_at desc' do
        expect(Todo.recent).to eq([ pending_todo, completed_todo, older_todo ])
      end
    end
  end

  describe 'factory' do
    it 'has a valid factory' do
      expect(build(:todo)).to be_valid
    end

    it 'has a valid completed_todo factory' do
      expect(build(:completed_todo)).to be_valid
    end

    it 'has a valid todo_without_description factory' do
      expect(build(:todo_without_description)).to be_valid
    end
  end

  describe 'database constraints' do
    it 'enforces title presence at database level' do
      todo = Todo.new(title: nil, completed: false)
      expect {
        todo.save!(validate: false)
      }.to raise_error(ActiveRecord::NotNullViolation)
    end

    it 'enforces completed presence at database level' do
      todo = Todo.new(title: 'Test title', completed: nil)
      expect {
        todo.save!(validate: false)
      }.to raise_error(ActiveRecord::NotNullViolation)
    end
  end
end
