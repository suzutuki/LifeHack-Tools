User.create!([{ name: "suzutuki",
                email: "example@railstutorial.org",
                password: "renath00",
                password_confirmation: "renath00",
                admin: true }, {
                name: "guest",
                email: "test@example.com",
                password: "guest00",
                password_confirmation: "guest00",
                admin: false
              }

# User.all.each do |user|
#   user.lists.create!(
#   [
#     {
#       question: '健康：健やかで体調よく生きる'
#     },
#     {
#       question: '開放：新たな体験、発想、選択肢に心を開く'
#     },
#     {
#       question: '成長：変化と成長を維持する'
#     },
#     {
#       question: '知識：価値ある知識を学ぶ、または生み出す'
#     },
#     {
#       question: '美的：身のまわりの美しいものを味わう'
#     },
#     {
#       question: '快適：喜びに満ちた快適な人生を送る'
#     },
#     {
#       question: '合理：理性と論理に従う'
#     },
#     {
#       question: '目的：人生の意味と方向性を定める'
#     },
#     {
#       question: '寛容：自分と違う存在を尊重して受け入れる'
#     },
#     {
#       question: '自制：自分の行動を自分でコントロールする'
#     },
#     {
#       question: '孤独：他人から離れて１人でいられる時間と空間を持つ'
#     },
#     {
#       question: '真実：自分が正しいと思うとおりに行動する'
#     },
#     {
#       question: '現実：現実的、実践的にふるまう'
#     },
#     {
#       question: '体力：丈夫で強い身体を保つ'
#     },
#     {
#       question: '冒険：新しくてワクワクする体験をする'
#     },
#     {
#       question: '精神：精神的に成長し成熟する'
#     },
#     {
#       question: '現在：いまの瞬間に集中して生きる'
#     },
#     {
#       question: '笑い：人生や世界のユーモラスな側面を見る'
#     },
#     {
#       question: '独立：他者に依存しないで生きる'
#     },
#     {
#       question: '勤勉：自分の仕事に一生懸命取り組む'
#     },
#     {
#       question: '平安：自分の内面の平和を維持する'
#     },
#     {
#       question: '余暇：自分の時間をリラックスして楽しむ'
#     },
#     {
#       question: '快楽：良い気分になること'
#     },
#     {
#       question: '自治：人まかせにしないで自分で決める'
#     },
#     {
#       question: '変化：変化に富んだバラエティ豊かな人生を送る'
#     },
#     {
#       question: '許し：他人を許しながら生きる'
#     },
#     {
#       question: '愉楽：遊んで楽しむこと'
#     },
#     {
#       question: '適度：過剰を避けてほどよいところを探す'
#     },
#     {
#       question: '挑戦：難しい仕事や問題に取り組む'
#     },
#     {
#       question: '単婚：唯一の愛し合える相手を見つける'
#     },
#     {
#       question: '反抗：権威やルールに疑問を持って挑む'
#     },
#     {
#       question: '寵愛：親しい人から愛される'
#     },
#     {
#       question: '熟達：いつもの仕事・作業に習熟する'
#     },
#     {
#       question: '慈愛：他者を心配して助ける'
#     },
#     {
#       question: '信頼：信用があって頼れる人間になる'
#     },
#     {
#       question: '安全：安心感を得る'
#     },
#     {
#       question: '受諾：ありのままの自分を受け入れる'
#     },
#     {
#       question: '自尊：自分に自信を持つ'
#     },
#     {
#       question: '自知：自分について深い理解を持つ'
#     },
#     {
#       question: '献身：誰かに奉仕する'
#     },
#     {
#       question: '単純：シンプルでミニマルな暮らしをする'
#     },
#     {
#       question: '安定：いつも一定して変化のない人生を送る'
#     },
#     {
#       question: '伝統：過去から受け継がれてきたパターンを尊重する'
#     },
#     {
#       question: '受容：ありのままの自分を受け入れてもらう'
#     },
#     {
#       question: '正確：自分の意見や信念正しく伝える'
#     },
#     {
#       question: '達成：なにか重要なことを達成する'
#     },
#     {
#       question: '性愛：活動的で満足のいく性生活を送る'
#     },
#     {
#       question: '責任：責任をもって行動する'
#     },
#     {
#       question: '危険：リスクを取ってチャンスを手に入れる'
#     },
#     {
#       question: '恋愛：興奮して燃えるような恋をする'
#     },
#     {
#       question: '人気：多くの人に好かれる'
#     },
#     {
#       question: '権力：他人をコントロールする'
#     },
#     {
#       question: '秩序：整理されて秩序のある人生を送る'
#     },
#     {
#       question: '情熱：なんらかの発想、活動、人々に深い感情を抱く'
#     },
#     {
#       question: '配慮：他人を心づかって世話すること'
#     },
#     {
#       question: '愛慕：誰かに愛をあたえる'
#     },
#     {
#       question: '親密：プライベートな体験を他人とシェアする'
#     },
#     {
#       question: '正義：すべての人を公平に扱う'
#     },
#     {
#       question: '信教：自分を超えた存在の意思を考える'
#     },
#     {
#       question: '有益：他人の役に立つこと'
#     },
#     {
#       question: '正直：ウソをつかず正直に生きる'
#     },
#     {
#       question: '希望：ポジティブで楽観的に生きる'
#     },
#     {
#       question: '謙遜：地味で控えめに生きる'
#     },
#     {
#       question: '義務：自分の義務と責任を果たす'
#     },
#     {
#       question: '調和：周囲の環境と調和しながら生きる'
#     },
#     {
#       question: '興奮：スリルと刺激に満ちた人生を送る'
#     },
#     {
#       question: '貞節：パートナーにウソをつかず誠実に生きる'
#     },
#     {
#       question: '名声：有名になって存在を認められる'
#     },
#     {
#       question: '家族：幸福で愛に満ちた家庭を作る'
#     },
#     {
#       question: '魅力：身体的な魅力を保つ'
#     },
#     {
#       question: '権威：他者に対して責任を持って指導する'
#     },
#     {
#       question: '貢献：世界の役に立つことをする'
#     },
#     {
#       question: '協調：他者と強力して何かをする'
#     },
#     {
#       question: '礼儀：他者に対して誠実で礼儀正しく接する'
#     },
#     {
#       question: '創造：新しくて斬新なアイデアを生む'
#     },
#     {
#       question: '友情：親密で助け合える友人を作る'
#     },
#     {
#       question: '寛大：自分の物を他人にあたえる'
#     }
#   ])
# end