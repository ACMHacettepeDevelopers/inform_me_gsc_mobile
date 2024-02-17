from google.cloud import translate_v2 as google_translate
from translate import Translator

class MyTranslator:

    def __init__(self, to_lang, debug=False):

        self._debug = debug
        self._to_lang = to_lang

        # use google package
        if not debug:
            self._translate_client = google_translate.Client()

        # use 3rd party package
        else:
            self._translate_client = Translator(to_lang=to_lang)

    def translate(self, text):
        """ Target must be an ISO 639-1 language code.
        See https://g.co/cloud/translate/v2/translate-reference#supported_languages """

        # if on debug mode use this library
        if self._debug:
            return self._translate_client.translate(text)

        else:
            result = self._translate_client.translate(text, target_language=self._to_lang)
            return result["translatedText"]