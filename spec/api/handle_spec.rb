RSpec.describe Handle do
  def new_handle
    Handle.new(
      partner_id:  ApiHelper::PARTNER_ID,
      partner_key: ApiHelper::PARTNER_KEY
    )
  end

  def partner_id
    ApiHelper::PARTNER_ID
  end

  def partner_key
    ApiHelper::PARTNER_KEY
  end

  def set_env_vars(partner_key:, partner_id:)
    ENV[Constants.partner_key_env_var] = partner_key
    ENV[Constants.partner_id_env_var]  = partner_id
  end

  context "instantiable from environment variables" do
    it "works" do
      set_env_vars(
        partner_key: ApiHelper::PARTNER_KEY,
        partner_id:  ApiHelper::PARTNER_ID
      )
      expect{Handle.init_from_env}.not_to raise_error
      expect(Handle.init_from_env.partner_id).to  eq(partner_id)
      expect(Handle.init_from_env.partner_key).to eq(partner_key)
    end

    context "requires variables from env" do
      EXPECTED_ERR_TYPE = StandardError
      EXPECTED_ERR_REGEX = /missing.environment.variable/i

      it "raises if required variables are nil" do
        set_env_vars(partner_key: nil, partner_id: nil)
        expect{
          Handle.init_from_env
        }.to raise_error(EXPECTED_ERR_TYPE, EXPECTED_ERR_REGEX)
      end

      it "raises if required variables are empty string" do
        set_env_vars(partner_key: '', partner_id: '')
        expect{
          Handle.init_from_env
        }.to raise_error(EXPECTED_ERR_TYPE, EXPECTED_ERR_REGEX)
      end

      it "raises if partner key is nil" do
        set_env_vars(partner_key: nil, partner_id: 'devconnect01')
        expect{
          Handle.init_from_env
        }.to raise_error(EXPECTED_ERR_TYPE, EXPECTED_ERR_REGEX)
      end

      it "raises if partner id is nil" do
        set_env_vars(partner_key: "afakepartnerkey", partner_id: nil)
        expect{
          Handle.init_from_env
        }.to raise_error(EXPECTED_ERR_TYPE, EXPECTED_ERR_REGEX)
      end
    end
  end

  it "returns a usable Standard object as expected" do
    expect(new_handle.standards).to be_a(AcademicBenchmarks::Api::Standards)
  end
end
