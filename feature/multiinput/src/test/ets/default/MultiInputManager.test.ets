/*
 * Copyright (c) Huawei Device Co., Ltd. 2024-2025. All rights reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import { describe, beforeAll, beforeEach, afterEach, afterAll, expect, it } from '@ohos/hypium'
import { multiInputManager } from '../../../main/ets/default/common/MultiInputManager'
import inputConsumer from '@ohos.multimodalInput.inputConsumer'
import keyCodeConstants from '../../../main/ets/default/common/constants/KeyCodeConstants';

/**
 * MultiInputManager测试
 *
 * @since 2023-11-30
 */
export default function MultiInputManagerTest() {
  describe('MultiInputManagerTest', (): void => {
    beforeAll((): void => {
    })

    beforeEach((): void => {
    })

    afterEach((): void => {
    })

    afterAll((): void => {
    })

    it('Test_shortcut_key_register', 0, (): void => {
      multiInputManager.registerTabInput();
      multiInputManager.unRegisterTabInput();
      let EscUpOption: inputConsumer.KeyOptions = {
        preKeys: [],
        finalKey: keyCodeConstants.KEYCODE_ESC,
        isFinalKeyDown: false,
        finalKeyDownDuration: 0
      };
      multiInputManager.registerTempInput(EscUpOption, () => {
      });
      multiInputManager.unRegisterTempInput(EscUpOption);
    })

    it('Test_pad_shortcut_key_register', 0, (): void => {
      multiInputManager.registerTabInput();
      multiInputManager.unRegisterTabInput();
    })

    it('Test_FnKeyBRIGHTNESS_DOWN_register', 0, (): void => {
      let brightnessFnOption: inputConsumer.KeyOptions = {
        preKeys: [],
        finalKey: keyCodeConstants.KEYCODE_BRIGHTNESS_DOWN,
        isFinalKeyDown: true,
        finalKeyDownDuration: 0
      };
      multiInputManager.registerTempInput(brightnessFnOption, () => {
      });
      multiInputManager.unRegisterTempInput(brightnessFnOption);
    })

    it('Test_FnKeyBRIGHTNESS_Up_register', 0, (): void => {
      let brightnessFnOption: inputConsumer.KeyOptions = {
        preKeys: [],
        finalKey: keyCodeConstants.KEYCODE_BRIGHTNESS_UP,
        isFinalKeyDown: true,
        finalKeyDownDuration: 0
      };
      multiInputManager.registerTempInput(brightnessFnOption, () => {
      });
      multiInputManager.unRegisterTempInput(brightnessFnOption);
    })

    it('Test_FnKeySysrq_register', 0, (): void => {
      multiInputManager.registerFnSysrqEvent();
      expect(multiInputManager.registerFnSysrqEvent() === undefined).assertTrue();
      multiInputManager.unRegisterFnSysrqEvent();
      expect(multiInputManager.unRegisterFnSysrqEvent() === undefined).assertTrue();
    })

    it('Test_FnKeyMute_register', 0, (): void => {
      let muteFnOption: inputConsumer.KeyOptions = {
        preKeys: [],
        finalKey: keyCodeConstants.KEYCODE_MUTE,
        isFinalKeyDown: true,
        finalKeyDownDuration: 0
      };
      multiInputManager.registerTempInput(muteFnOption, () => {
      });
      multiInputManager.unRegisterTempInput(muteFnOption);
    })

    it('Test_FnKeySearch_register', 0, (): void => {
      let searchFnOption: inputConsumer.KeyOptions = {
        preKeys: [],
        finalKey: keyCodeConstants.KEYCODE_SEARCH,
        isFinalKeyDown: true,
        finalKeyDownDuration: 0
      };
      multiInputManager.registerTempInput(searchFnOption, () => {
      });
      multiInputManager.unRegisterTempInput(searchFnOption);
    })

    it('Test_FnKeyProjection_register', 0, (): void => {
      let projectionFnOption: inputConsumer.KeyOptions = {
        preKeys: [],
        finalKey: keyCodeConstants.KEYCODE_SWITCHVIDEOMODE,
        isFinalKeyDown: true,
        finalKeyDownDuration: 0
      };
      multiInputManager.registerTempInput(projectionFnOption, () => {
      });
      multiInputManager.unRegisterTempInput(projectionFnOption);
    })

    it('Test_screenRecord_register', 0, (): void => {
      let screenRecordFnOption: inputConsumer.KeyOptions = {
        preKeys: [],
        finalKey: keyCodeConstants.KEYCODE_SWITCHVIDEOMODE,
        isFinalKeyDown: true,
        finalKeyDownDuration: 0
      };
      multiInputManager.registerTempInput(screenRecordFnOption, () => {
      });
      multiInputManager.unRegisterTempInput(screenRecordFnOption);
    })

    it('Test_screenRecord_register', 0, (): void => {
      let screenRecordFnOption: inputConsumer.KeyOptions = {
        preKeys: [],
        finalKey: keyCodeConstants.KEYCODE_MEDIA_RECORD,
        isFinalKeyDown: true,
        finalKeyDownDuration: 0
      };
      multiInputManager.registerTempInput(screenRecordFnOption, () => {
      });
      multiInputManager.unRegisterTempInput(screenRecordFnOption);
    })

    it('Test_WinA_register', 0, (): void => {
      let winAOption: inputConsumer.KeyOptions = {
        preKeys: [keyCodeConstants.KEYCODE_WIN],
        finalKey: keyCodeConstants.KEYCODE_A,
        isFinalKeyDown: true,
        finalKeyDownDuration: 0
      };
      multiInputManager.registerTempInput(winAOption, () => {
      });
      multiInputManager.unRegisterTempInput(winAOption);
    })

    it('Test_WinC_register', 0, (): void => {
      let winCOption: inputConsumer.KeyOptions = {
        preKeys: [keyCodeConstants.KEYCODE_WIN],
        finalKey: keyCodeConstants.KEYCODE_C,
        isFinalKeyDown: true,
        finalKeyDownDuration: 0
      };
      multiInputManager.registerTempInput(winCOption, () => {
      });
      multiInputManager.unRegisterTempInput(winCOption);
    })

    it('Test_WinD_register', 0, (): void => {
      let winDOption: inputConsumer.KeyOptions = {
        preKeys: [keyCodeConstants.KEYCODE_WIN],
        finalKey: keyCodeConstants.KEYCODE_D,
        isFinalKeyDown: true,
        finalKeyDownDuration: 0
      };
      multiInputManager.registerTempInput(winDOption, () => {
      });
      multiInputManager.unRegisterTempInput(winDOption);
    })

    it('Test_WinDpadUp_register', 0, (): void => {
      let winDpadUpOption: inputConsumer.KeyOptions = {
        preKeys: [keyCodeConstants.KEYCODE_WIN],
        finalKey: keyCodeConstants.KEYCODE_DPAD_UP,
        isFinalKeyDown: true,
        finalKeyDownDuration: 0
      };
      multiInputManager.registerTempInput(winDpadUpOption, () => {
      });
      multiInputManager.unRegisterTempInput(winDpadUpOption);
    })

    it('Test_WinF_register', 0, (): void => {
      let winFOption: inputConsumer.KeyOptions = {
        preKeys: [keyCodeConstants.KEYCODE_WIN],
        finalKey: keyCodeConstants.KEYCODE_F,
        isFinalKeyDown: true,
        finalKeyDownDuration: 0
      };
      multiInputManager.registerTempInput(winFOption, () => {
      });
      multiInputManager.unRegisterTempInput(winFOption);
    })

    it('Test_WinM_register', 0, (): void => {
      let winMOption: inputConsumer.KeyOptions = {
        preKeys: [keyCodeConstants.KEYCODE_WIN],
        finalKey: keyCodeConstants.KEYCODE_D,
        isFinalKeyDown: true,
        finalKeyDownDuration: 0
      };
      multiInputManager.registerTempInput(winMOption, () => {
      });
      multiInputManager.unRegisterTempInput(winMOption);
    })

    it('Test_AltLeftShiftRightF4_register', 0, (): void => {
      let altShiftF4Option: inputConsumer.KeyOptions = {
        preKeys: [keyCodeConstants.KEYCODE_ALT_LEFT,keyCodeConstants.KEYCODE_SHIFT_RIGHT],
        finalKey: keyCodeConstants.KEYCODE_F4,
        isFinalKeyDown: true,
        finalKeyDownDuration: 0
      };
      multiInputManager.registerTempInput(altShiftF4Option, () => {
      });
      multiInputManager.unRegisterTempInput(altShiftF4Option);
    })

    it('Test_AltRightShiftLeftF4_register', 0, (): void => {
      let altShiftF4Option: inputConsumer.KeyOptions = {
        preKeys: [keyCodeConstants.KEYCODE_ALT_RIGHT,keyCodeConstants.KEYCODE_SHIFT_LEFT],
        finalKey: keyCodeConstants.KEYCODE_F4,
        isFinalKeyDown: true,
        finalKeyDownDuration: 0
      };
      multiInputManager.registerTempInput(altShiftF4Option, () => {
      });
      multiInputManager.unRegisterTempInput(altShiftF4Option);
    })

    it('Test_AltRightShiftRightF4_register', 0, (): void => {
      let altShiftF4Option: inputConsumer.KeyOptions = {
        preKeys: [keyCodeConstants.KEYCODE_ALT_RIGHT,keyCodeConstants.KEYCODE_SHIFT_RIGHT],
        finalKey: keyCodeConstants.KEYCODE_F4,
        isFinalKeyDown: true,
        finalKeyDownDuration: 0
      };
      multiInputManager.registerTempInput(altShiftF4Option, () => {
      });
      multiInputManager.unRegisterTempInput(altShiftF4Option);
    })


    it('Test_altRightTab_register', 0, (): void => {
      let altRightTabOption: inputConsumer.KeyOptions = {
        preKeys: [keyCodeConstants.KEYCODE_ALT_RIGHT],
        finalKey: keyCodeConstants.KEYCODE_TAB,
        isFinalKeyDown: true,
        finalKeyDownDuration: 0
      };
      multiInputManager.registerTempInput(altRightTabOption, () => {
      });
      multiInputManager.unRegisterTempInput(altRightTabOption);
    })

    it('Test_altLeftTab_register', 0, (): void => {
      let altLeftTabOption: inputConsumer.KeyOptions = {
        preKeys: [keyCodeConstants.KEYCODE_ALT_LEFT],
        finalKey: keyCodeConstants.KEYCODE_TAB,
        isFinalKeyDown: true,
        finalKeyDownDuration: 0
      };
      multiInputManager.registerTempInput(altLeftTabOption, () => {
      });
      multiInputManager.unRegisterTempInput(altLeftTabOption);
    })

    it('Test_winLDown_register', 0, (): void => {
      let winLDownOption: inputConsumer.KeyOptions = {
        preKeys: [keyCodeConstants.KEYCODE_WIN],
        finalKey: keyCodeConstants.KEYCODE_L,
        isFinalKeyDown: true,
        finalKeyDownDuration: 0,
        isRepeat: false
      };
      multiInputManager.registerTempInput(winLDownOption, () => {
      });
      multiInputManager.unRegisterTempInput(winLDownOption);
    })

    it('Test_winTab_register', 0, (): void => {
      let winTabOption: inputConsumer.KeyOptions = {
        preKeys: [keyCodeConstants.KEYCODE_WIN],
        finalKey: keyCodeConstants.KEYCODE_TAB,
        isFinalKeyDown: true,
        finalKeyDownDuration: 0,
        isRepeat: false
      };
      multiInputManager.registerTempInput(winTabOption, () => {
      });
      multiInputManager.unRegisterTempInput(winTabOption);
    })

    it('Test_winD_register', 0, (): void => {
      let winDOption: inputConsumer.KeyOptions = {
        preKeys: [keyCodeConstants.KEYCODE_WIN],
        finalKey: keyCodeConstants.KEYCODE_D,
        isFinalKeyDown: true,
        finalKeyDownDuration: 0,
        isRepeat: false
      };
      multiInputManager.registerTempInput(winDOption, () => {
      });
      multiInputManager.unRegisterTempInput(winDOption);
    })

    it('Test_dWin_register', 0, (): void => {
      let dWinOption: inputConsumer.KeyOptions = {
        preKeys: [keyCodeConstants.KEYCODE_D],
        finalKey: keyCodeConstants.KEYCODE_WIN,
        isFinalKeyDown: false,
        finalKeyDownDuration: 6000
      };
      multiInputManager.registerTempInput(dWinOption, () => {
      });
      multiInputManager.unRegisterTempInput(dWinOption);
    })

    it('Test_winUp_register', 0, (): void => {
      let winUpOption: inputConsumer.KeyOptions = {
        preKeys: [],
        finalKey: keyCodeConstants.KEYCODE_WIN,
        isFinalKeyDown: false,
        finalKeyDownDuration: 0,
        isRepeat: false
      };
      multiInputManager.registerTempInput(winUpOption, () => {
      });
      multiInputManager.unRegisterTempInput(winUpOption);
    })

    it('Test_altRightUp_register', 0, (): void => {
      let altRightUpOption: inputConsumer.KeyOptions = {
        preKeys: [],
        finalKey: keyCodeConstants.KEYCODE_ALT_RIGHT,
        isFinalKeyDown: false,
        finalKeyDownDuration: 0
      };
      multiInputManager.registerTempInput(altRightUpOption, () => {
      });
      multiInputManager.unRegisterTempInput(altRightUpOption);
    })

    it('Test_tabUp_register', 0, (): void => {
      let tabUpOption: inputConsumer.KeyOptions = {
        preKeys: [],
        finalKey: keyCodeConstants.KEYCODE_TAB,
        isFinalKeyDown: false,
        finalKeyDownDuration: 0
      };
      multiInputManager.registerTempInput(tabUpOption, () => {
      });
      multiInputManager.unRegisterTempInput(tabUpOption);
    })

    it('Test_winTabUp_register', 0, (): void => {
      let winTabUpOption: inputConsumer.KeyOptions = {
        preKeys: [keyCodeConstants.KEYCODE_WIN],
        finalKey: keyCodeConstants.KEYCODE_TAB,
        isFinalKeyDown: false,
        finalKeyDownDuration: 6000,
        isRepeat: false
      };
      multiInputManager.registerTempInput(winTabUpOption, () => {
      });
      multiInputManager.unRegisterTempInput(winTabUpOption);
    })

    it('Test_winShiftS_register', 0, (): void => {
      let winShiftSDownOption: inputConsumer.KeyOptions = {
        preKeys: [keyCodeConstants.KEYCODE_WIN, keyCodeConstants.KEYCODE_SHIFT_LEFT],
        finalKey: keyCodeConstants.KEYCODE_S,
        isFinalKeyDown: true,
        finalKeyDownDuration: 0,
        isRepeat: false
      };
      multiInputManager.registerTempInput(winShiftSDownOption, () => {
      });
      multiInputManager.unRegisterTempInput(winShiftSDownOption);
    })

    it('Test_winShiftS_register', 0, (): void => {
      let winShiftSDownOption: inputConsumer.KeyOptions = {
        preKeys: [keyCodeConstants.KEYCODE_WIN, keyCodeConstants.KEYCODE_SHIFT_RIGHT],
        finalKey: keyCodeConstants.KEYCODE_S,
        isFinalKeyDown: true,
        finalKeyDownDuration: 0,
        isRepeat: false
      };
      multiInputManager.registerTempInput(winShiftSDownOption, () => {
      });
      multiInputManager.unRegisterTempInput(winShiftSDownOption);
    })

    it('Test_winShiftRDown_register', 0, (): void => {
      let winShiftRDownOption: inputConsumer.KeyOptions = {
        preKeys: [keyCodeConstants.KEYCODE_WIN, keyCodeConstants.KEYCODE_SHIFT_LEFT],
        finalKey: keyCodeConstants.KEYCODE_R,
        isFinalKeyDown: true,
        finalKeyDownDuration: 0,
        isRepeat: false
      };
      multiInputManager.registerTempInput(winShiftRDownOption, () => {
      });
      multiInputManager.unRegisterTempInput(winShiftRDownOption);
    })

    it('Test_winShiftRDown1_register', 0, (): void => {
      let winShiftRDownOption: inputConsumer.KeyOptions = {
        preKeys: [keyCodeConstants.KEYCODE_WIN, keyCodeConstants.KEYCODE_SHIFT_RIGHT],
        finalKey: keyCodeConstants.KEYCODE_R,
        isFinalKeyDown: true,
        finalKeyDownDuration: 0,
        isRepeat: false
      };
      multiInputManager.registerTempInput(winShiftRDownOption, () => {
      });
      multiInputManager.unRegisterTempInput(winShiftRDownOption);
    })

    it('Test_altLeftF4_register', 0, (): void => {
      let altLeftF4Option: inputConsumer.KeyOptions = {
        preKeys: [keyCodeConstants.KEYCODE_ALT_LEFT],
        finalKey: keyCodeConstants.KEYCODE_F4,
        isFinalKeyDown: true,
        finalKeyDownDuration: 0,
        isRepeat: false
      };
      multiInputManager.registerTempInput(altLeftF4Option, () => {
      });
      multiInputManager.unRegisterTempInput(altLeftF4Option);
    })

    it('Test_winSlashDown_register', 0, (): void => {
      let winSlashDownOption: inputConsumer.KeyOptions = {
        preKeys: [keyCodeConstants.KEYCODE_WIN],
        finalKey: keyCodeConstants.KEYCODE_SLASH,
        isFinalKeyDown: true,
        finalKeyDownDuration: 0,
        isRepeat: false
      };
      multiInputManager.registerTempInput(winSlashDownOption, () => {
      });
      multiInputManager.unRegisterTempInput(winSlashDownOption);
    })

    it('Test_altRightF4_register', 0, (): void => {
      let altRightF4Option: inputConsumer.KeyOptions = {
        preKeys: [keyCodeConstants.KEYCODE_ALT_RIGHT],
        finalKey: keyCodeConstants.KEYCODE_F4,
        isFinalKeyDown: true,
        finalKeyDownDuration: 0
      };
      multiInputManager.registerTempInput(altRightF4Option, () => {
      });
      multiInputManager.unRegisterTempInput(altRightF4Option);
    })

    it('Test_winDpapUP_register', 0, (): void => {
      let slashWinUpOption: inputConsumer.KeyOptions = {
        preKeys: [keyCodeConstants.KEYCODE_WIN],
        finalKey: keyCodeConstants.KEYCODE_DPAD_UP,
        isFinalKeyDown: false,
        finalKeyDownDuration: 6000
      };
      multiInputManager.registerTempInput(slashWinUpOption, () => {
      });
      multiInputManager.unRegisterTempInput(slashWinUpOption);
    })

    it('Test_ctrlShiftEscDown_register', 0, (): void => {
      let ctrlShiftEscDownOption: inputConsumer.KeyOptions = {
        preKeys: [keyCodeConstants.KEYCODE_CTRL_LEFT, keyCodeConstants.KEYCODE_SHIFT_LEFT],
        finalKey: keyCodeConstants.KEYCODE_ESC,
        isFinalKeyDown: true,
        finalKeyDownDuration: 0
      };
      multiInputManager.registerTempInput(ctrlShiftEscDownOption, () => {
      });
      multiInputManager.unRegisterTempInput(ctrlShiftEscDownOption);
    })

    it('Test_winNDown_register', 0, (): void => {
      let dpapUPWinOption: inputConsumer.KeyOptions = {
        preKeys: [keyCodeConstants.KEYCODE_WIN],
        finalKey: keyCodeConstants.KEYCODE_N,
        isFinalKeyDown: true,
        finalKeyDownDuration: 0,
        isRepeat: false
      };
      multiInputManager.registerTempInput(dpapUPWinOption, () => {
      });
      multiInputManager.unRegisterTempInput(dpapUPWinOption);
    })

    it('Test_winFDown_register', 0, (): void => {
      let winFDownOption: inputConsumer.KeyOptions = {
        preKeys: [keyCodeConstants.KEYCODE_WIN],
        finalKey: keyCodeConstants.KEYCODE_F,
        isFinalKeyDown: true,
        finalKeyDownDuration: 0,
        isRepeat: false
      };
      multiInputManager.registerTempInput(winFDownOption, () => {
      });
      multiInputManager.unRegisterTempInput(winFDownOption);
    })

    it('Test_winADown_register', 0, (): void => {
      let winSDownOption: inputConsumer.KeyOptions = {
        preKeys: [keyCodeConstants.KEYCODE_WIN],
        finalKey: keyCodeConstants.KEYCODE_S,
        isFinalKeyDown: true,
        finalKeyDownDuration: 0,
        isRepeat: false
      };
      multiInputManager.registerTempInput(winSDownOption, () => {
      });
      multiInputManager.unRegisterTempInput(winSDownOption);
    })

    it('Test_winSDown_register', 0, (): void => {
      let winSDownOption: inputConsumer.KeyOptions = {
        preKeys: [keyCodeConstants.KEYCODE_WIN],
        finalKey: keyCodeConstants.KEYCODE_S,
        isFinalKeyDown: true,
        finalKeyDownDuration: 0
      };
      multiInputManager.registerTempInput(winSDownOption, () => {
      });
      multiInputManager.unRegisterTempInput(winSDownOption);
    })

    it('Test_winMDown_register', 0, (): void => {
      let winMDownOption: inputConsumer.KeyOptions = {
        preKeys: [keyCodeConstants.KEYCODE_WIN],
        finalKey: keyCodeConstants.KEYCODE_M,
        isFinalKeyDown: true,
        finalKeyDownDuration: 0,
        isRepeat: false
      };
      multiInputManager.registerTempInput(winMDownOption, () => {
      });
      multiInputManager.unRegisterTempInput(winMDownOption);
    })

    it('Test_winSlashDown_register', 0, (): void => {
      let winSlashDownOption: inputConsumer.KeyOptions = {
        preKeys: [keyCodeConstants.KEYCODE_WIN],
        finalKey: keyCodeConstants.KEYCODE_SLASH,
        isFinalKeyDown: true,
        finalKeyDownDuration: 0
      };
      multiInputManager.registerTempInput(winSlashDownOption, () => {
      });
      multiInputManager.unRegisterTempInput(winSlashDownOption);
    })

    it('Test_altLeftF4_register', 0, (): void => {
      let altLeftF4Option: inputConsumer.KeyOptions = {
        preKeys: [keyCodeConstants.KEYCODE_ALT_LEFT],
        finalKey: keyCodeConstants.KEYCODE_F4,
        isFinalKeyDown: true,
        finalKeyDownDuration: 0,
        isRepeat: false
      };
      multiInputManager.registerTempInput(altLeftF4Option, () => {
      });
      multiInputManager.unRegisterTempInput(altLeftF4Option);
    })

    it('Test_winBackSpaceDown_register', 0, (): void => {
      let winBackSpaceUpOption: inputConsumer.KeyOptions = {
        preKeys: [keyCodeConstants.KEYCODE_WIN],
        finalKey: keyCodeConstants.KEYCODE_DEL,
        isFinalKeyDown: true,
        finalKeyDownDuration: 0,
        isRepeat: false
      };
      multiInputManager.registerTempInput(winBackSpaceUpOption, () => {
      });
      multiInputManager.unRegisterTempInput(winBackSpaceUpOption);
    })

    it('Test_winMDown_register', 0, (): void => {
      let winMDownOption: inputConsumer.KeyOptions = {
        preKeys: [keyCodeConstants.KEYCODE_WIN],
        finalKey: keyCodeConstants.KEYCODE_M,
        isFinalKeyDown: true,
        finalKeyDownDuration: 0
      };
      multiInputManager.registerTempInput(winMDownOption, () => {
      });
      multiInputManager.unRegisterTempInput(winMDownOption);
    })

    it('Test_ctrlShiftEscDown_register', 0, (): void => {
      let ctrlShiftEscDownOption: inputConsumer.KeyOptions = {
        preKeys: [keyCodeConstants.KEYCODE_CTRL_LEFT, keyCodeConstants.KEYCODE_SHIFT_LEFT],
        finalKey: keyCodeConstants.KEYCODE_ESC,
        isFinalKeyDown: true,
        finalKeyDownDuration: 0
      };
      multiInputManager.registerTempInput(ctrlShiftEscDownOption, () => {
      });
      multiInputManager.unRegisterTempInput(ctrlShiftEscDownOption);
    })

    it('Test_altLeftUp_register', 0, (): void => {
      let altLeftUpOption: inputConsumer.KeyOptions = {
        preKeys: [],
        finalKey: keyCodeConstants.KEYCODE_ALT_LEFT,
        isFinalKeyDown: false,
        finalKeyDownDuration: 0,
      };
      multiInputManager.registerTempInput(altLeftUpOption, () => {
      });
      multiInputManager.unRegisterTempInput(altLeftUpOption);
    })

    it('Test_winSpaceUp_register', 0, (): void => {
      let winSpaceUpOption: inputConsumer.KeyOptions = {
        preKeys: [keyCodeConstants.KEYCODE_WIN],
        finalKey: keyCodeConstants.KEYCODE_SPACE,
        isFinalKeyDown: false,
        finalKeyDownDuration: 0,
        isRepeat: false
      };
      multiInputManager.registerTempInput(winSpaceUpOption, () => {
      });
      multiInputManager.unRegisterTempInput(winSpaceUpOption);
    })

    it('Test_ctrlShiftUp_register', 0, (): void => {
      let ctrlShiftUpOption: inputConsumer.KeyOptions = {
        preKeys: [keyCodeConstants.KEYCODE_CTRL_LEFT],
        finalKey: keyCodeConstants.KEYCODE_SHIFT_LEFT,
        isFinalKeyDown: false,
        finalKeyDownDuration: 0
      };
      multiInputManager.registerTempInput(ctrlShiftUpOption, () => {
      });
      multiInputManager.unRegisterTempInput(ctrlShiftUpOption);
    })

    it('Test_winDpapUP_register', 0, (): void => {
      let slashWinUpOption: inputConsumer.KeyOptions = {
        preKeys: [keyCodeConstants.KEYCODE_WIN],
        finalKey: keyCodeConstants.KEYCODE_DPAD_UP,
        isFinalKeyDown: true,
        finalKeyDownDuration: 0,
        isRepeat: false
      };
      multiInputManager.registerTempInput(slashWinUpOption, () => {
      });
      multiInputManager.unRegisterTempInput(slashWinUpOption);
    })

    it('Test_winNDown_register', 0, (): void => {
      let dpapUPWinOption: inputConsumer.KeyOptions = {
        preKeys: [keyCodeConstants.KEYCODE_WIN],
        finalKey: keyCodeConstants.KEYCODE_N,
        isFinalKeyDown: true,
        finalKeyDownDuration: 0,
      };
      multiInputManager.registerTempInput(dpapUPWinOption, () => {
      });
      multiInputManager.unRegisterTempInput(dpapUPWinOption);
    })

    it('Test_winADown_register', 0, (): void => {
      let winADownOption: inputConsumer.KeyOptions = {
        preKeys: [keyCodeConstants.KEYCODE_WIN],
        finalKey: keyCodeConstants.KEYCODE_A,
        isFinalKeyDown: true,
        finalKeyDownDuration: 0,
        isRepeat: false
      };
      multiInputManager.registerTempInput(winADownOption, () => {
      });
      multiInputManager.unRegisterTempInput(winADownOption);
    })
  })
}