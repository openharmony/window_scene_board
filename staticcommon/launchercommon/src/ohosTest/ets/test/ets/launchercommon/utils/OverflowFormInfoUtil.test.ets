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

import formInfo from '@ohos.app.form.formInfo';
import {
  afterAll,
  afterEach,
  beforeAll,
  beforeEach,
  it,
  describe,
  expect,
  MockKit,
  ArgumentMatchers,
  when
} from '@ohos/hypium';
import { OverflowFormInfoUtil } from '../../../../../../main/ets/utils/OverflowFormInfoUtil';
import { CardItemInfo } from '../../../../../../main/ets/bean/CardItemInfo';
import { OverflowConstants } from '@ohos/commonconstants';
import { GridLayoutItemInfo, GridLayoutItemBuilder } from '../../../../../../main/ets/TsIndex';
import { GameCardInfo } from '../../../../../../main/ets/bean/GameCardInfo';
import { AppItemInfo } from '../../../../../../main/ets/bean/AppItemInfo';
import { FormModel } from '../../../../../../main/ets/model/FormModel';

function createQuickGameCardInfo(): CardItemInfo{
  let formItem: CardItemInfo = new CardItemInfo();
  formItem.area = [4, 4];
  formItem.cardId = '111';
  formItem.moduleName = 'scene_board';
  formItem.cardName = 'stackingBoxCard';
  return formItem;
}

function createFunInteractionCardInfo(): CardItemInfo{
  let formItem: CardItemInfo = new CardItemInfo();
  formItem.area = [4, 4];
  formItem.cardId = '222';
  formItem.moduleName = 'scene_board';
  formItem.cardName = 'funInteractionCard';
  return formItem;
}

function createSceneAnimationCardInfo(): CardItemInfo{
  let formItem: CardItemInfo = new CardItemInfo();
  formItem.area = [4, 4];
  formItem.cardId = '333';
  formItem.moduleName = 'scene_board';
  formItem.cardName = 'sceneAnimationCard';
  return formItem;
}

function createGameCardInfo(): GameCardInfo {
  let gameCardInfo = {
    gameType: 'quick',
    formBindGame: 'com.openharmony.StackingBoxes',
    extensionType: '',
    formBindAbility: '',
    disabledDesktopBehaviors: '',
    pauseDuration: 0,
    isEquals: (info: GameCardInfo) : boolean => {
      return false;
    }
  } as GameCardInfo;
  return gameCardInfo;
}

function createGridLayoutInfo(): GridLayoutItemInfo {
  let layoutInfo: GridLayoutItemInfo = {
    bundleName: 'test',
    abilityName: 'test',
    appIconId: 1234,
    negativeId: 1234,
    isSelect: false,
    enterEditing: false,
    downloadProgress: 0,
    appStatus: 0,
    iconResource: '',
    callerName: '',
    setInfo: (gridLayoutItemBuilder: GridLayoutItemBuilder): void => {
      throw new Error('Function not implemented.');
    },
    fillInfoWithAppItem: (appItem: AppItemInfo): GridLayoutItemInfo => {
      throw new Error('Function not implemented.');
    },
    toAppItemInfo: (): AppItemInfo => {
      throw new Error('Function not implemented.');
    }
  };

  return layoutInfo;
}

export function OverflowFormInfoUtilTest() {
  describe('OverflowFormInfoUtilTest', () => {
    beforeAll(() => {
    });

    beforeEach(() => {
    });

    afterAll(() => {
    });

    afterEach(() => {
    });

    it('test_fillOverflowCardInfo', 0, () => {
      const formItem: formInfo.FormInfo = {
        bundleName: 'test',
        moduleName: 'test',
        abilityName: 'test',
        name: 'form',
        displayName: '',
        displayNameId: 0,
        description: '',
        descriptionId: 0,
        type: 1,
        jsComponentName: '',
        colorMode: 0,
        isDefault: false,
        updateEnabled: false,
        formVisibleNotify: false,
        scheduledUpdateTime: '',
        formConfigAbility: '',
        updateDuration: 0,
        defaultDimension: 0,
        supportDimensions: [],
        customizeData: {
          'gameType': 'quick'
        },
        isDynamic: false,
        transparencyEnabled: false,
        supportedShapes: [],
        renderingMode: 0,
      };
      let cardItemInfo: CardItemInfo = createQuickGameCardInfo();
      OverflowFormInfoUtil.fillOverflowCardInfo(formItem, cardItemInfo);
      expect(OverflowFormInfoUtil).not().assertNull();
    })

    it('test_fillOverflowCardInfo_01', 0, () => {
      const formItem: formInfo.FormInfo = {
        bundleName: 'test',
        moduleName: 'test',
        abilityName: 'test',
        name: 'form',
        displayName: '',
        displayNameId: 0,
        description: '',
        descriptionId: 0,
        type: 1,
        jsComponentName: '',
        colorMode: 0,
        isDefault: false,
        updateEnabled: false,
        formVisibleNotify: false,
        scheduledUpdateTime: '',
        formConfigAbility: '',
        updateDuration: 0,
        defaultDimension: 0,
        supportDimensions: [],
        customizeData: {
        },
        isDynamic: false,
        transparencyEnabled: false,
        supportedShapes: [],
        renderingMode: 0,
        funInteractionParams:{
          "targetBundleName": "testBundleName",
          "subBundleName": "testBundleName"
        }
      };
      let cardItemInfo: CardItemInfo = createFunInteractionCardInfo();
      OverflowFormInfoUtil.fillOverflowCardInfo(formItem, cardItemInfo);
      expect(OverflowFormInfoUtil).not().assertNull();
    })

    it('test_fillOverflowCardInfo_02', 0, () => {
      const formItem: formInfo.FormInfo = {
        bundleName: 'test',
        moduleName: 'test',
        abilityName: 'test',
        name: 'form',
        displayName: '',
        displayNameId: 0,
        description: '',
        descriptionId: 0,
        type: 1,
        jsComponentName: '',
        colorMode: 0,
        isDefault: false,
        updateEnabled: false,
        formVisibleNotify: false,
        scheduledUpdateTime: '',
        formConfigAbility: '',
        updateDuration: 0,
        defaultDimension: 0,
        supportDimensions: [],
        customizeData: {
        },
        isDynamic: false,
        transparencyEnabled: false,
        supportedShapes: [],
        renderingMode: 0,
        sceneAnimationParams:{
          "abilityName": "testAbility"
        }
      };
      let cardItemInfo: CardItemInfo = createSceneAnimationCardInfo();
      OverflowFormInfoUtil.fillOverflowCardInfo(formItem, cardItemInfo);
      expect(OverflowFormInfoUtil).not().assertNull();
    })

    it('test_fillOverflowCardInfoInGridLayout_01', 0, () => {
      let layoutInfo = createGridLayoutInfo();
      OverflowFormInfoUtil.fillOverflowCardInfoInGridLayout(layoutInfo);
      expect(layoutInfo.gameCardInfo).assertNull();
    })

    it('test_fillOverflowCardInfoInGridLayout_02', 0, () => {
      let layoutInfo = createGridLayoutInfo();
      layoutInfo.cardName = 'test';

      let formItem: CardItemInfo = new CardItemInfo();
      formItem.cardId = '333';
      formItem.bundleName = 'test';
      formItem.cardName = 'test';
      formItem.gameCardInfo = createGameCardInfo();
      let newFormInfos: CardItemInfo[] = [formItem];
      const mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(FormModel, FormModel.getInstance().getAppItemFormInfo);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(newFormInfos);

      OverflowFormInfoUtil.fillOverflowCardInfoInGridLayout(layoutInfo);
      expect(layoutInfo.gameCardInfo).not().assertNull();
    })

    it('test_parseLiveFormCardInfo_01', 0, () => {
      let result = OverflowFormInfoUtil.parseLiveFormCardInfo('');
      expect(result).assertUndefined();
    })

    it('test_parseLiveFormCardInfo_02', 0, () => {
      let intent = '{\"gameCardInfo\":{\"gameType\":\"quick\",\"formBindGame\":\"com.openharmony.StackingBoxes\"}}';
      let result =
        OverflowFormInfoUtil.parseLiveFormCardInfo(intent);
      expect(result).not().assertNull();
    })

    it('test_updateLiveFromData_01', 0, () => {
      let intentMap: Map<string, Object> = new Map();
      let result = OverflowFormInfoUtil.updateLiveFromData(intentMap, '', OverflowConstants.INTENT_KEY_LIVE_FORM_CARD);
      expect(result).assertUndefined();
    })

    it('test_updateLiveFromData_02', 0, () => {
      let intentMap: Map<string, Object> = new Map();
      let intent = '{\"gameCardInfo\":{\"gameType\":\"quick\",\"formBindGame\":\"com.openharmony.StackingBoxes\"}}';
      let result =
        OverflowFormInfoUtil.updateLiveFromData(intentMap, intent, OverflowConstants.INTENT_KEY_LIVE_FORM_CARD);
      expect(result).not().assertNull();
    })
  })
}
