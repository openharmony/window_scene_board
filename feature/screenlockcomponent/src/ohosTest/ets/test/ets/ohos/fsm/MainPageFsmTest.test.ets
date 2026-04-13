/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2025. All rights reserved.
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

import {
  afterAll,
  afterEach,
  beforeAll,
  beforeEach,
  describe,
  expect,
  it
} from '@ohos/hypium';
import { MainPageFsm, MpEventType, MpStateType } from '@ohos/screenlockcommon/src/main/ets/fsm/MainPageFsm';
import TestConst from '../constants/TestConst';

export default function MainPageFsmTest() {
  const persistentId: number = 1;

  describe('MainPageFsmTest', (): void => {
    let mainPageFsm: MainPageFsm;

    // 状态预设函数
    const initMainPageFsm = (stateType: MpStateType): void => {
      switch (stateType) {
        case MpStateType.INIT_STATE:
          break;
        case MpStateType.EDIT_NORMAL_STATE:
          mainPageFsm.submitEvent(MpEventType.ENTER_MAIN_PAGE_EDIT);
          break;
        case MpStateType.EDIT_MAIN_PAGE_STATE_FULL:
          mainPageFsm.submitEvent(MpEventType.ENTER_MAIN_PAGE_EDIT);
          mainPageFsm.submitEvent(MpEventType.ENTER_EDIT_MAIN_PAGE_FULL);
          break;
        case MpStateType.EDIT_CLOCK_STATE:
          mainPageFsm.submitEvent(MpEventType.ENTER_MAIN_PAGE_EDIT);
          mainPageFsm.submitEvent(MpEventType.ENTER_EDIT_CLOCK);
          break;
        case MpStateType.EDIT_CARD_STATE:
          mainPageFsm.submitEvent(MpEventType.ENTER_MAIN_PAGE_EDIT);
          mainPageFsm.submitEvent(MpEventType.ENTER_EDIT_CARD);
          break;
        case MpStateType.EDIT_CARD_DETAIL_STATE:
          mainPageFsm.submitEvent(MpEventType.ENTER_MAIN_PAGE_EDIT);
          mainPageFsm.submitEvent(MpEventType.ENTER_EDIT_CARD);
          mainPageFsm.submitEvent(MpEventType.ENTER_EDIT_CARD_DETAIL);
          break;
        case MpStateType.EDIT_WALLPAPER_STATE:
          mainPageFsm.submitEvent(MpEventType.ENTER_MAIN_PAGE_EDIT);
          mainPageFsm.submitEvent(MpEventType.ENTER_EDIT_WALLPAPER);
          break;
        case MpStateType.EDIT_AOD_STYLE_STATE:
          mainPageFsm.submitEvent(MpEventType.ENTER_MAIN_PAGE_EDIT);
          mainPageFsm.submitEvent(MpEventType.ENTER_EDIT_AOD_STYLE);
          break;
        case MpStateType.EDIT_THEME_STATE:
          mainPageFsm.submitEvent(MpEventType.ENTER_MAIN_PAGE_EDIT);
          mainPageFsm.submitEvent(MpEventType.ENTER_EDIT_THEME);
          break;
      }
      expect(mainPageFsm.currentStateType).assertEqual(stateType);
    };

    beforeAll((): void => {
    })
    beforeEach((): void => {
      mainPageFsm = new MainPageFsm(persistentId);
    })
    afterEach((): void => {
    })
    afterAll((): void => {
    })

    it('test_submitEvent_when_send_sb_to_en_return_normal_unlock', TestConst.TEST_LEVEL, (): void => {
      initMainPageFsm(MpStateType.EDIT_NORMAL_STATE);

      mainPageFsm.submitEvent(MpEventType.SLIDE_BACK);

      expect(mainPageFsm.currentStateType).assertEqual(MpStateType.NORMAL_UNLOCK_STATE);
    })

    it('test_submitEvent_when_send_edmpf_to_en_return_edit_mpf', TestConst.TEST_LEVEL, (): void => {
      initMainPageFsm(MpStateType.EDIT_NORMAL_STATE);

      mainPageFsm.submitEvent(MpEventType.ENTER_EDIT_MAIN_PAGE_FULL);

      expect(mainPageFsm.currentStateType).assertEqual(MpStateType.EDIT_MAIN_PAGE_STATE_FULL);
    })

    it('test_submitEvent_when_send_eec_to_en_return_edit_clock', TestConst.TEST_LEVEL, (): void => {
      initMainPageFsm(MpStateType.EDIT_NORMAL_STATE);

      mainPageFsm.submitEvent(MpEventType.ENTER_EDIT_CLOCK);

      expect(mainPageFsm.currentStateType).assertEqual(MpStateType.EDIT_CLOCK_STATE);
    })

    it('test_submitEvent_when_send_eec_to_en_return_edit_clock', TestConst.TEST_LEVEL, (): void => {
      initMainPageFsm(MpStateType.EDIT_NORMAL_STATE);

      mainPageFsm.submitEvent(MpEventType.ENTER_EDIT_CARD);

      expect(mainPageFsm.currentStateType).assertEqual(MpStateType.EDIT_CARD_STATE);
    })

    it('test_submitEvent_when_send_eew_to_en_return_edit_wallpaper', TestConst.TEST_LEVEL, (): void => {
      initMainPageFsm(MpStateType.EDIT_NORMAL_STATE);

      mainPageFsm.submitEvent(MpEventType.ENTER_EDIT_WALLPAPER);

      expect(mainPageFsm.currentStateType).assertEqual(MpStateType.EDIT_WALLPAPER_STATE);
    })

    it('test_submitEvent_when_send_eeas_to_en_return_edit_aodStyle', TestConst.TEST_LEVEL, (): void => {
      initMainPageFsm(MpStateType.EDIT_NORMAL_STATE);

      mainPageFsm.submitEvent(MpEventType.ENTER_EDIT_AOD_STYLE);

      expect(mainPageFsm.currentStateType).assertEqual(MpStateType.EDIT_AOD_STYLE_STATE);
    })

    it('test_submitEvent_when_send_eet_to_en_return_edit_theme', TestConst.TEST_LEVEL, (): void => {
      initMainPageFsm(MpStateType.EDIT_NORMAL_STATE);

      mainPageFsm.submitEvent(MpEventType.ENTER_EDIT_THEME);

      expect(mainPageFsm.currentStateType).assertEqual(MpStateType.EDIT_THEME_STATE);
    })

    it('test_submitEvent_when_send_empe_to_en_return_edit_normal', TestConst.TEST_LEVEL, (): void => {
      initMainPageFsm(MpStateType.EDIT_NORMAL_STATE);

      mainPageFsm.submitEvent(MpEventType.ENTER_MAIN_PAGE_EDIT);

      expect(mainPageFsm.currentStateType).assertEqual(MpStateType.EDIT_NORMAL_STATE);
    })

    it('test_submitEvent_when_send_sb_to_emp_return_edit_normal', TestConst.TEST_LEVEL, (): void => {
      initMainPageFsm(MpStateType.EDIT_MAIN_PAGE_STATE_FULL);

      mainPageFsm.submitEvent(MpEventType.SLIDE_BACK);

      expect(mainPageFsm.currentStateType).assertEqual(MpStateType.EDIT_NORMAL_STATE);
    })

    it('test_submitEvent_when_send_eempsfb_to_emp_return_edit_normal', TestConst.TEST_LEVEL, (): void => {
      initMainPageFsm(MpStateType.EDIT_MAIN_PAGE_STATE_FULL);

      mainPageFsm.submitEvent(MpEventType.EXIT_EDIT_MAIN_PAGE_STATE_FULL_BACK);

      expect(mainPageFsm.currentStateType).assertEqual(MpStateType.EDIT_NORMAL_STATE);
    })

    it('test_submitEvent_when_send_eec_to_emp_return_edit_clock', TestConst.TEST_LEVEL, (): void => {
      initMainPageFsm(MpStateType.EDIT_MAIN_PAGE_STATE_FULL);

      mainPageFsm.submitEvent(MpEventType.ENTER_EDIT_CLOCK);

      expect(mainPageFsm.currentStateType).assertEqual(MpStateType.EDIT_CLOCK_STATE);
    })

    it('test_submitEvent_when_send_eec_to_emp_return_edit_card', TestConst.TEST_LEVEL, (): void => {
      initMainPageFsm(MpStateType.EDIT_MAIN_PAGE_STATE_FULL);

      mainPageFsm.submitEvent(MpEventType.ENTER_EDIT_CARD);

      expect(mainPageFsm.currentStateType).assertEqual(MpStateType.EDIT_CARD_STATE);
    })

    it('test_submitEvent_when_send_empe_to_emp_return_edit_mpf', TestConst.TEST_LEVEL, (): void => {
      initMainPageFsm(MpStateType.EDIT_MAIN_PAGE_STATE_FULL);

      mainPageFsm.submitEvent(MpEventType.ENTER_MAIN_PAGE_EDIT);

      expect(mainPageFsm.currentStateType).assertEqual(MpStateType.EDIT_MAIN_PAGE_STATE_FULL);
    })

    it('test_submitEvent_when_send_sb_to_ecl_return_edit_normal', TestConst.TEST_LEVEL, (): void => {
      initMainPageFsm(MpStateType.EDIT_CLOCK_STATE);

      mainPageFsm.submitEvent(MpEventType.SLIDE_BACK);

      expect(mainPageFsm.currentStateType).assertEqual(MpStateType.EDIT_NORMAL_STATE);
    })

    it('test_submitEvent_when_send_eempsfb_to_ecl_return_edit_normal', TestConst.TEST_LEVEL, (): void => {
      initMainPageFsm(MpStateType.EDIT_CLOCK_STATE);

      mainPageFsm.submitEvent(MpEventType.EXIT_EDIT_MAIN_PAGE_STATE_FULL_BACK);

      expect(mainPageFsm.currentStateType).assertEqual(MpStateType.EDIT_NORMAL_STATE);
    })

    it('test_submitEvent_when_send_eempf_to_ecl_return_edit_mpf', TestConst.TEST_LEVEL, (): void => {
      initMainPageFsm(MpStateType.EDIT_CLOCK_STATE);

      mainPageFsm.submitEvent(MpEventType.ENTER_EDIT_MAIN_PAGE_FULL);

      expect(mainPageFsm.currentStateType).assertEqual(MpStateType.EDIT_MAIN_PAGE_STATE_FULL);
    })

    it('test_submitEvent_when_send_eec_to_ecl_return_edit_card', TestConst.TEST_LEVEL, (): void => {
      initMainPageFsm(MpStateType.EDIT_CLOCK_STATE);

      mainPageFsm.submitEvent(MpEventType.ENTER_EDIT_CARD);

      expect(mainPageFsm.currentStateType).assertEqual(MpStateType.EDIT_CARD_STATE);
    })

    it('test_submitEvent_when_send_empe_to_ecl_return_edit_clock', TestConst.TEST_LEVEL, (): void => {
      initMainPageFsm(MpStateType.EDIT_CLOCK_STATE);

      mainPageFsm.submitEvent(MpEventType.ENTER_MAIN_PAGE_EDIT);

      expect(mainPageFsm.currentStateType).assertEqual(MpStateType.EDIT_CLOCK_STATE);
    })

    it('test_submitEvent_when_send_sb_to_eca_return_edit_mpf', TestConst.TEST_LEVEL, (): void => {
      initMainPageFsm(MpStateType.EDIT_CARD_STATE);

      mainPageFsm.submitEvent(MpEventType.SLIDE_BACK);

      expect(mainPageFsm.currentStateType).assertEqual(MpStateType.EDIT_MAIN_PAGE_STATE_FULL);
    })

    it('test_submitEvent_when_send_eempf_to_eca_return_edit_mpf', TestConst.TEST_LEVEL, (): void => {
      initMainPageFsm(MpStateType.EDIT_CARD_STATE);

      mainPageFsm.submitEvent(MpEventType.ENTER_EDIT_MAIN_PAGE_FULL);

      expect(mainPageFsm.currentStateType).assertEqual(MpStateType.EDIT_MAIN_PAGE_STATE_FULL);
    })

    it('test_submitEvent_when_send_eempsfb_to_eca_return_edit_normal', TestConst.TEST_LEVEL, (): void => {
      initMainPageFsm(MpStateType.EDIT_CARD_STATE);

      mainPageFsm.submitEvent(MpEventType.EXIT_EDIT_MAIN_PAGE_STATE_FULL_BACK);

      expect(mainPageFsm.currentStateType).assertEqual(MpStateType.EDIT_NORMAL_STATE);
    })

    it('test_submitEvent_when_send_eec_to_eca_return_edit_clock', TestConst.TEST_LEVEL, (): void => {
      initMainPageFsm(MpStateType.EDIT_CARD_STATE);

      mainPageFsm.submitEvent(MpEventType.ENTER_EDIT_CLOCK);

      expect(mainPageFsm.currentStateType).assertEqual(MpStateType.EDIT_CLOCK_STATE);
    })

    it('test_submitEvent_when_send_eecd_to_eca_return_edit_card_detail', TestConst.TEST_LEVEL, (): void => {
      initMainPageFsm(MpStateType.EDIT_CARD_STATE);

      mainPageFsm.submitEvent(MpEventType.ENTER_EDIT_CARD_DETAIL);

      expect(mainPageFsm.currentStateType).assertEqual(MpStateType.EDIT_CARD_DETAIL_STATE);
    })

    it('test_submitEvent_when_send_empe_to_eca_return_edit_card', TestConst.TEST_LEVEL, (): void => {
      initMainPageFsm(MpStateType.EDIT_CARD_STATE);

      mainPageFsm.submitEvent(MpEventType.ENTER_MAIN_PAGE_EDIT);

      expect(mainPageFsm.currentStateType).assertEqual(MpStateType.EDIT_CARD_STATE);
    })

    it('test_submitEvent_when_send_sb_to_ecad_return_edit_card', TestConst.TEST_LEVEL, (): void => {
      initMainPageFsm(MpStateType.EDIT_CARD_DETAIL_STATE);

      mainPageFsm.submitEvent(MpEventType.SLIDE_BACK);

      expect(mainPageFsm.currentStateType).assertEqual(MpStateType.EDIT_CARD_STATE);
    })

    it('test_submitEvent_when_send_empe_to_ecad_return_edit_card_detail', TestConst.TEST_LEVEL, (): void => {
      initMainPageFsm(MpStateType.EDIT_CARD_DETAIL_STATE);

      mainPageFsm.submitEvent(MpEventType.ENTER_MAIN_PAGE_EDIT);

      expect(mainPageFsm.currentStateType).assertEqual(MpStateType.EDIT_CARD_DETAIL_STATE);
    })

    it('test_submitEvent_when_send_sb_to_ewp_return_edit_normal', TestConst.TEST_LEVEL, (): void => {
      initMainPageFsm(MpStateType.EDIT_WALLPAPER_STATE);

      mainPageFsm.submitEvent(MpEventType.SLIDE_BACK);

      expect(mainPageFsm.currentStateType).assertEqual(MpStateType.EDIT_NORMAL_STATE);
    })

    it('test_submitEvent_when_send_eee_to_ewp_return_edit_normal', TestConst.TEST_LEVEL, (): void => {
      initMainPageFsm(MpStateType.EDIT_WALLPAPER_STATE);

      mainPageFsm.submitEvent(MpEventType.EXIT_EDIT_EXTENSION);

      expect(mainPageFsm.currentStateType).assertEqual(MpStateType.EDIT_NORMAL_STATE);
    })

    it('test_submitEvent_when_send_empe_to_ewp_return_edit_wallpaper', TestConst.TEST_LEVEL, (): void => {
      initMainPageFsm(MpStateType.EDIT_WALLPAPER_STATE);

      mainPageFsm.submitEvent(MpEventType.ENTER_MAIN_PAGE_EDIT);

      expect(mainPageFsm.currentStateType).assertEqual(MpStateType.EDIT_WALLPAPER_STATE);
    })

    it('test_submitEvent_when_send_sb_to_eas_return_edit_normal', TestConst.TEST_LEVEL, (): void => {
      initMainPageFsm(MpStateType.EDIT_AOD_STYLE_STATE);

      mainPageFsm.submitEvent(MpEventType.SLIDE_BACK);

      expect(mainPageFsm.currentStateType).not().assertNull();
    })

    it('test_submitEvent_when_send_eee_to_eas_return_edit_normal', TestConst.TEST_LEVEL, (): void => {
      initMainPageFsm(MpStateType.EDIT_AOD_STYLE_STATE);

      mainPageFsm.submitEvent(MpEventType.EXIT_EDIT_EXTENSION);

      expect(mainPageFsm.currentStateType).not().assertNull();
    })

    it('test_submitEvent_when_send_empe_to_eas_return_edit_aodStyle', TestConst.TEST_LEVEL, (): void => {
      initMainPageFsm(MpStateType.EDIT_AOD_STYLE_STATE);

      mainPageFsm.submitEvent(MpEventType.ENTER_MAIN_PAGE_EDIT);

      expect(mainPageFsm.currentStateType).assertEqual(MpStateType.EDIT_AOD_STYLE_STATE);
    })

    it('test_submitEvent_when_send_sb_to_eas_return_edit_normal_one', TestConst.TEST_LEVEL, (): void => {
      initMainPageFsm(MpStateType.EDIT_THEME_STATE);

      mainPageFsm.submitEvent(MpEventType.SLIDE_BACK);

      expect(mainPageFsm.currentStateType).not().assertNull();
    })

    it('test_submitEvent_when_send_eee_to_eas_return_edit_normal', TestConst.TEST_LEVEL, (): void => {
      initMainPageFsm(MpStateType.EDIT_THEME_STATE);

      mainPageFsm.submitEvent(MpEventType.EXIT_EDIT_EXTENSION);

      expect(mainPageFsm.currentStateType).not().assertNull();
    })

    it('test_submitEvent_when_send_empe_to_eas_return_edit_theme', TestConst.TEST_LEVEL, (): void => {
      initMainPageFsm(MpStateType.EDIT_THEME_STATE);

      mainPageFsm.submitEvent(MpEventType.ENTER_MAIN_PAGE_EDIT);

      expect(mainPageFsm.currentStateType).not().assertNull();
    })

    it('test_submitEvent_when_send_sb_to_eas_return_edit_normal', TestConst.TEST_LEVEL, (): void => {
      initMainPageFsm(MpStateType.EDIT_CUSTOM_THEME_STATE);

      mainPageFsm.submitEvent(MpEventType.SLIDE_BACK);

      expect(mainPageFsm.currentStateType).assertEqual(MpStateType.EDIT_NORMAL_STATE);
    })

    it('test_submitEvent_when_send_eee_to_eas_return_edit_normal', TestConst.TEST_LEVEL, (): void => {
      initMainPageFsm(MpStateType.EDIT_CUSTOM_THEME_STATE);

      mainPageFsm.submitEvent(MpEventType.EXIT_EDIT_EXTENSION);

      expect(mainPageFsm.currentStateType).not().assertNull();
    })

    it('test_submitEvent_when_send_empe_to_eas_return_edit_theme_one', TestConst.TEST_LEVEL, (): void => {
      initMainPageFsm(MpStateType.EDIT_CUSTOM_THEME_STATE);

      mainPageFsm.submitEvent(MpEventType.ENTER_MAIN_PAGE_EDIT);

      expect(mainPageFsm.currentStateType).not().assertNull();
    })
  })
}