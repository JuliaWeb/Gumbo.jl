@testset "`text`" begin
    doc = parsehtml("<em>foo</em>bar<em></em>baz")
    @test text(doc.root) == "foobarbaz"

    doc = parsehtml("<math><mrow><msub><mrow><mi>MoSe</mi></mrow><mrow><mn>2</mn></mrow></msub></mrow></math>")
    @test text(doc.root) == "MoSe2"
end