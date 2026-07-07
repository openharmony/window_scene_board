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

import { JsonUtils, LogDomain, LogHelper } from "@ohos/basicutils";
import { afterAll, beforeAll, beforeEach, afterEach, describe, it, expect, MockKit, when,
  ArgumentMatchers } from "@ohos/hypium";
import {
  GridLayoutItemInfo,
} from "@ohos/launchercommon";
import { AgentInfo } from "@ohos/launchercommon/src/main/ets/aisuggestion/AgentInfo";
import { AiSuggestionConstants } from "@ohos/launchercommon/src/main/ets/aisuggestion/AiSuggestionConstants";
import { CardResourceInfo } from "@ohos/launchercommon/src/main/ets/aisuggestion/CardResourceInfo";
import { InputCardRecInfo } from "@ohos/launchercommon/src/main/ets/aisuggestion/InputCardRecInfo";
import { LauncherRecItem } from "@ohos/launchercommon/src/main/ets/aisuggestion/LauncherRecItem";
import { PortfolioInfo } from "@ohos/launchercommon/src/main/ets/aisuggestion/PortfolioInfo";
import { NeedDelayShow } from "../../../../../../main/ets/default/constants/NeedDelayShow";
import { PortfolioInfoDisplayMode } from "../../../../../../main/ets/default/constants/PortfolioInfoDisplayMode";
import { AiSuggestionDataHelper } from "../../../../../../main/ets/default/helper/AiSuggestionDataHelper";

const TAG = 'AiSuggestionDataHelperTest';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.AISUGGESTION, TAG);

/**
 * AiSuggestionDataHelper测试
 *
 * @since 2025-06-17
 */
export function AiSuggestionDataHelperTest() {
  describe('AiSuggestionDataHelperTest', (): void => {
    beforeAll((): void => {

    });

    beforeEach((): void => {

    });

    /**
     * 测试语音助手建议获取点击的数据
     */
    it('AiSuggestionDataHelperTest_getRealRecItem', 0, (): void => {
      const recItem1: LauncherRecItem = new LauncherRecItem();
      const recItems1: LauncherRecItem[] = [];
      const getRecItem1: LauncherRecItem | undefined = AiSuggestionDataHelper.getRealRecItem(recItem1, recItems1);
      expect(getRecItem1).assertEqual(recItem1);

      const recItem2: LauncherRecItem = new LauncherRecItem();
      recItem2.serviceId = 'testServiceId';
      recItem2.itemType = AiSuggestionConstants.TYPE_CARD;
      const recItems2: LauncherRecItem[] = [];
      const getRecItem2: LauncherRecItem | undefined = AiSuggestionDataHelper.getRealRecItem(recItem2, recItems2);
      expect(getRecItem2).assertEqual(recItem1);

      const recItem3: LauncherRecItem = new LauncherRecItem();
      recItem3.serviceId = 'testServiceId';
      recItem3.itemType = AiSuggestionConstants.TYPE_CARD;
      const recItems3: LauncherRecItem[] = [];
      recItems3.push(recItem3);
      const getRecItem3: LauncherRecItem | undefined = AiSuggestionDataHelper.getRealRecItem(recItem3, recItems3);
      expect(getRecItem3).assertEqual(recItem3);

      const recItem4: LauncherRecItem = new LauncherRecItem();
      recItem4.serviceId = 'testServiceId';
      recItem4.itemType = AiSuggestionConstants.TYPE_APP;
      const recItems4: LauncherRecItem[] = [];
      recItems3.push(recItem4);
      const getRecItem4: LauncherRecItem | undefined = AiSuggestionDataHelper.getRealRecItem(recItem4, recItems4);
      expect(getRecItem4).assertEqual(recItem4);

      const recItem5: LauncherRecItem = new LauncherRecItem();
      recItem5.serviceId = 'testServiceId';
      recItem5.itemType = AiSuggestionConstants.TYPE_APP;
      const subRecItem1 = new LauncherRecItem();
      subRecItem1.itemType = AiSuggestionConstants.TYPE_APP_GROUP;
      subRecItem1.serviceId = 'testServiceId';
      recItem5.subLauncherRecItems = [];
      recItem5.subLauncherRecItems.push(subRecItem1);
      const recItems5: LauncherRecItem[] = [];
      recItems5.push(recItem5);
      const getRecItem5: LauncherRecItem | undefined = AiSuggestionDataHelper.getRealRecItem(recItem5, recItems5);
      expect(getRecItem5).assertEqual(recItems5[0]);
    });
  });

  /**
   * 判断是否需要显示场景信息
   */
  it('AiSuggestionDataHelperTest_isNeedShowPortfolioInfo', 0, (): void => {
    const portfolioInfo: PortfolioInfo | undefined = undefined;
    const isArrivedTime: boolean = true;
    const showPortfolioInfo: boolean = AiSuggestionDataHelper.isNeedShowPortfolioInfo(portfolioInfo, isArrivedTime);
    expect(showPortfolioInfo).assertFalse();

    let portfolioInfo1: PortfolioInfo = {
      title: "",
      desc1: "",
      desc2: "",
      desc: "",
      name: "",
      portfolioId: "",
      backBoardStyle: 0,
      displayMode: PortfolioInfoDisplayMode.DISPLAY_MODE_DISAPPEAR,
      delaySeconds: 0,
      dark: new CardResourceInfo(),
      light: new CardResourceInfo(),
      agentInfo: new AgentInfo(),
      multiLanguages: {
        name: {

        },
        desc: {

        },
        desc1: {

        },
        desc2: {

        },
      }
    };

    expect(AiSuggestionDataHelper.isNeedShowPortfolioInfo(portfolioInfo1, true)).assertTrue();

    portfolioInfo1.displayMode = PortfolioInfoDisplayMode.DISPLAY_MODE_EXIST;
    expect(AiSuggestionDataHelper.isNeedShowPortfolioInfo(portfolioInfo1, true)).assertTrue();

    portfolioInfo1.displayMode = PortfolioInfoDisplayMode.DISPLAY_MODE_DISAPPEAR;
    expect(AiSuggestionDataHelper.isNeedShowPortfolioInfo(portfolioInfo1, false)).assertFalse();

    portfolioInfo1.displayMode = PortfolioInfoDisplayMode.DISPLAY_MODE_NOT_EXIST;
    expect(AiSuggestionDataHelper.isNeedShowPortfolioInfo(portfolioInfo1, true)).assertFalse();
  })

  it('atc_should_return_empty_want_when_recItem_or_formItem_is_null', 0, () => {
    let mocker: MockKit = new MockKit();
    let mockShowWarn: Function = mocker.mockFunc(log, log.showWarn);
    when(mockShowWarn)(ArgumentMatchers.anyString).afterReturnNothing();

    let recItem: LauncherRecItem = new LauncherRecItem();
    let formItem: GridLayoutItemInfo = new GridLayoutItemInfo();
    let disableGesture: boolean = false;
    const result: ESObject = AiSuggestionDataHelper.getWant(recItem, formItem, disableGesture);
    expect(result).assertDeepEquals({});
    mocker.ignoreMock(log, log.showWarn);
  });

  it('atc_should_return_want_with_parameters_when_recItem_and_formItem_are_valid', 0, () => {
    let mocker: MockKit = new MockKit();
    let mockShowInfo: Function = mocker.mockFunc(log, log.showInfo);
    when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();

    let recItem: LauncherRecItem = new LauncherRecItem();
    recItem.isTransparent = true;
    recItem.formWantInfo = '';
    recItem.recInfo = new InputCardRecInfo();
    recItem.recInfo.parentFormId = '123';
    let formItem: GridLayoutItemInfo = new GridLayoutItemInfo();
    formItem.cardId = '456';
    let disableGesture: boolean = false;
    const result: ESObject = AiSuggestionDataHelper.getWant(recItem, formItem, disableGesture);
    expect(result.parameters).assertDeepEquals({
      formWantInfo: recItem.formWantInfo,
      recInfo: JsonUtils.toJson(recItem.recInfo),
    });
    mocker.ignoreMock(log, log.showInfo);
  });

  it('atc_should_return_want_with_extra_parameters_when_disableGesture_is_true', 0, () => {
    let mocker: MockKit = new MockKit();
    let mockShowInfo: Function = mocker.mockFunc(log, log.showInfo);
    when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();

    let recItem: LauncherRecItem = new LauncherRecItem();
    recItem.isTransparent = true;
    recItem.formWantInfo = '';
    recItem.recInfo = new InputCardRecInfo();
    recItem.recInfo.parentFormId = '123';
    let formItem: GridLayoutItemInfo = new GridLayoutItemInfo();
    formItem.cardId = '456';
    let disableGesture: boolean = true;
    const result: ESObject = AiSuggestionDataHelper.getWant(recItem, formItem, disableGesture);
    expect(result.parameters).assertDeepEquals({
      formWantInfo: recItem.formWantInfo,
      recInfo: JsonUtils.toJson(recItem.recInfo),
      'AiSuggestionConstants.DISABLE_GESTURE': disableGesture,
    });
    mocker.ignoreMock(log, log.showInfo);
  });

  it('checkDisplay_test1', 0, () => {
    const recItem: LauncherRecItem = new LauncherRecItem();
    let portfolioInfo: PortfolioInfo | undefined = undefined;
    const show = AiSuggestionDataHelper.checkDisplay(recItem, portfolioInfo, true, []);
    expect(show).assertTrue();
  });

  it('checkDisplay_test2', 0, () => {
    const recItem: LauncherRecItem = new LauncherRecItem();
    recItem.needDelayShow = NeedDelayShow.NEED_DELAY_SHOW;
    let portfolioInfo: PortfolioInfo = {
      title: "",
      desc1: "",
      desc2: "",
      desc: "",
      name: "",
      portfolioId: 'portfolioId',
      backBoardStyle: 0,
      displayMode: PortfolioInfoDisplayMode.DISPLAY_MODE_DISAPPEAR,
      delaySeconds: 0,
      dark: new CardResourceInfo(),
      light: new CardResourceInfo(),
      agentInfo: new AgentInfo(),
      multiLanguages: {
        name: {

        },
        desc: {

        },
        desc1: {

        },
        desc2: {

        },
      }
    };
    const show = AiSuggestionDataHelper.checkDisplay(recItem, portfolioInfo, false, []);
    expect(show).assertFalse();
  });

  it('checkDisplay_test3', 0, () => {
    const recItem: LauncherRecItem = new LauncherRecItem();
    recItem.needDelayShow = NeedDelayShow.NEED_DELAY_SHOW;
    let portfolioInfo: PortfolioInfo = {
      title: "",
      desc1: "",
      desc2: "",
      desc: "",
      name: "",
      portfolioId: 'portfolioId',
      backBoardStyle: 0,
      displayMode: PortfolioInfoDisplayMode.DISPLAY_MODE_DISAPPEAR,
      delaySeconds: 0,
      dark: new CardResourceInfo(),
      light: new CardResourceInfo(),
      agentInfo: new AgentInfo(),
      multiLanguages: {
        name: {

        },
        desc: {

        },
        desc1: {

        },
        desc2: {

        },
      }
    };
    const show = AiSuggestionDataHelper.checkDisplay(recItem, portfolioInfo, true, []);
    expect(show).assertTrue();
  });

  it('checkDisplay_test4', 0, () => {
    const recItem: LauncherRecItem = new LauncherRecItem();
    recItem.needDelayShow = NeedDelayShow.NOT_NEED_DELAY_SHOW;
    let portfolioInfo: PortfolioInfo = {
      title: "",
      desc1: "",
      desc2: "",
      desc: "",
      name: "",
      portfolioId: 'portfolioId',
      backBoardStyle: 0,
      displayMode: PortfolioInfoDisplayMode.DISPLAY_MODE_DISAPPEAR,
      delaySeconds: 0,
      dark: new CardResourceInfo(),
      light: new CardResourceInfo(),
      agentInfo: new AgentInfo(),
      multiLanguages: {
        name: {

        },
        desc: {

        },
        desc1: {

        },
        desc2: {

        },
      }
    };
    const show = AiSuggestionDataHelper.checkDisplay(recItem, portfolioInfo, false, []);
    expect(show).assertTrue();
  });

  it('checkDisplay_test5', 0, () => {
    const recItem: LauncherRecItem = new LauncherRecItem();
    recItem.needDelayShow = NeedDelayShow.NOT_NEED_DELAY_SHOW;
    recItem.rowStart = 1;
    recItem.rowSpan = 1;
    recItem.columnStart = 1;
    recItem.columnSpan = 1;
    let portfolioInfo: PortfolioInfo = {
      title: "",
      desc1: "",
      desc2: "",
      desc: "",
      name: "",
      portfolioId: 'portfolioId',
      backBoardStyle: 0,
      displayMode: PortfolioInfoDisplayMode.DISPLAY_MODE_EXIST,
      delaySeconds: 0,
      dark: new CardResourceInfo(),
      light: new CardResourceInfo(),
      agentInfo: new AgentInfo(),
      multiLanguages: {
        name: {

        },
        desc: {

        },
        desc1: {

        },
        desc2: {

        },
      }
    };
    const show = AiSuggestionDataHelper.checkDisplay(recItem, portfolioInfo, false, [0, 0]);
    expect(show).assertTrue();
  });

  it('checkDisplay_test6', 0, () => {
    const recItem: LauncherRecItem = new LauncherRecItem();
    recItem.needDelayShow = NeedDelayShow.NOT_NEED_DELAY_SHOW;
    recItem.rowStart = 1;
    recItem.rowSpan = 1;
    recItem.columnStart = 1;
    recItem.columnSpan = 1;
    let portfolioInfo: PortfolioInfo = {
      title: "",
      desc1: "",
      desc2: "",
      desc: "",
      name: "",
      portfolioId: 'portfolioId',
      backBoardStyle: 0,
      displayMode: PortfolioInfoDisplayMode.DISPLAY_MODE_EXIST,
      delaySeconds: 0,
      dark: new CardResourceInfo(),
      light: new CardResourceInfo(),
      agentInfo: new AgentInfo(),
      multiLanguages: {
        name: {

        },
        desc: {

        },
        desc1: {

        },
        desc2: {

        },
      }
    };
    const show = AiSuggestionDataHelper.checkDisplay(recItem, portfolioInfo, false, [1, 0]);
    expect(show).assertTrue();
  });

  it('checkDisplay_test7', 0, () => {
    const recItem: LauncherRecItem = new LauncherRecItem();
    recItem.needDelayShow = NeedDelayShow.NOT_NEED_DELAY_SHOW;
    recItem.rowStart = 1;
    recItem.rowSpan = 1;
    recItem.columnStart = 1;
    recItem.columnSpan = 1;
    let portfolioInfo: PortfolioInfo = {
      title: "",
      desc1: "",
      desc2: "",
      desc: "",
      name: "",
      portfolioId: 'portfolioId',
      backBoardStyle: 0,
      displayMode: PortfolioInfoDisplayMode.DISPLAY_MODE_EXIST,
      delaySeconds: 0,
      dark: new CardResourceInfo(),
      light: new CardResourceInfo(),
      agentInfo: new AgentInfo(),
      multiLanguages: {
        name: {

        },
        desc: {

        },
        desc1: {

        },
        desc2: {

        },
      }
    };
    const show = AiSuggestionDataHelper.checkDisplay(recItem, portfolioInfo, false, [0, 1]);
    expect(show).assertTrue();
  });

  it('checkDisplay_test8', 0, () => {
    const recItem: LauncherRecItem = new LauncherRecItem();
    recItem.needDelayShow = NeedDelayShow.NOT_NEED_DELAY_SHOW;
    recItem.rowStart = 1;
    recItem.rowSpan = 1;
    recItem.columnStart = 1;
    recItem.columnSpan = 1;
    let portfolioInfo: PortfolioInfo = {
      title: "",
      desc1: "",
      desc2: "",
      desc: "",
      name: "",
      portfolioId: 'portfolioId',
      backBoardStyle: 0,
      displayMode: PortfolioInfoDisplayMode.DISPLAY_MODE_EXIST,
      delaySeconds: 0,
      dark: new CardResourceInfo(),
      light: new CardResourceInfo(),
      agentInfo: new AgentInfo(),
      multiLanguages: {
        name: {

        },
        desc: {

        },
        desc1: {

        },
        desc2: {

        },
      }
    };
    const show = AiSuggestionDataHelper.checkDisplay(recItem, portfolioInfo, false, [1, 1]);
    expect(show).assertFalse();
  });

  it('checkDisplay_test9', 0, () => {
    const recItem: LauncherRecItem = new LauncherRecItem();
    recItem.needDelayShow = NeedDelayShow.NOT_NEED_DELAY_SHOW;
    recItem.rowStart = 1;
    recItem.rowSpan = 1;
    recItem.columnStart = 1;
    recItem.columnSpan = 1;
    let portfolioInfo: PortfolioInfo = {
      title: "",
      desc1: "",
      desc2: "",
      desc: "",
      name: "",
      portfolioId: 'portfolioId',
      backBoardStyle: 0,
      displayMode: PortfolioInfoDisplayMode.DISPLAY_MODE_NOT_EXIST,
      delaySeconds: 0,
      dark: new CardResourceInfo(),
      light: new CardResourceInfo(),
      agentInfo: new AgentInfo(),
      multiLanguages: {
        name: {

        },
        desc: {

        },
        desc1: {

        },
        desc2: {

        },
      }
    };
    const show = AiSuggestionDataHelper.checkDisplay(recItem, portfolioInfo, false, [1, 1]);
    expect(show).assertTrue();
  });
}