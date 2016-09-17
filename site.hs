--------------------------------------------------------------------------------
{-# LANGUAGE OverloadedStrings #-}
import           Data.Monoid         (mappend)

import qualified Data.Set            as S
import           Hakyll              hiding (pandocCompiler)
import           Text.Pandoc.Options


--------------------------------------------------------------------------------
main :: IO ()
main = hakyllWith config $ do

    match "CNAME" $ do
        route   idRoute
        compile copyFileCompiler

    match "fonts/*" $ do
        route   idRoute
        compile copyFileCompiler

    match "docs/*" $ do
        route   idRoute
        compile copyFileCompiler

    match "docs/papers/*" $ do
        route   idRoute
        compile copyFileCompiler

    match "docs/posters/*" $ do
        route   idRoute
        compile copyFileCompiler

    match "img/*" $ do
        route   idRoute
        compile copyFileCompiler

    match "css/*" $ do
        route   idRoute
        compile compressCssCompiler

    match (fromList ["index.md", "research.md", "projects.md", "about-me.md", "404.md"]) $ do
        route   $ setExtension "html"
        compile $ pandocCompiler
            >>= loadAndApplyTemplate "templates/default.html" defaultContext
            >>= relativizeUrls

    match "templates/*" $ compile templateBodyCompiler


--------------------------------------------------------------------------------

config = defaultConfiguration {
          deployCommand = "git stash &&" ++
                          " git checkout develop &&" ++
                          " stack exec site clean &&" ++
                          " stack exec site build &&" ++
                          " git checkout master &&" ++
                          " rsync -a --filter='P _site/' \
                                    \--filter='P _cache/' \
                                    \--filter='P .git/' \
                                    \--filter='P .gitignore' \
                                    \--delete-excluded _site/ . && " ++
                          " echo 'Updated site.'; " ++
                          " git add . && " ++
                          " git commit -m \"Publish.\" && " ++
                          " git push origin master:master; " ++
                          " git checkout develop && " ++
                          " git add . && " ++
                          " git commit -m \"Update.\" && " ++
                          " git push origin develop:develop && " ++
                          " git stash pop "
          }

pandocCompiler :: Compiler (Item String)
pandocCompiler =
  let customExtensions = [Ext_link_attributes, Ext_implicit_figures,
                          Ext_tex_math_dollars, Ext_tex_math_single_backslash,
                          Ext_latex_macros]
      defaultExtensions = writerExtensions defaultHakyllWriterOptions
      newExtensions = foldr S.insert defaultExtensions customExtensions
      writerOptions = defaultHakyllWriterOptions {
                        writerExtensions = newExtensions,
                        writerHTMLMathMethod = MathJax ""
                      }
    in pandocCompilerWith defaultHakyllReaderOptions writerOptions
