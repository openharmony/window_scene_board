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

import {
  afterAll,
  afterEach,
  beforeAll,
  beforeEach,
  it,
  describe,
  expect,
  MockKit,
  when,
  ArgumentMatchers,
} from '@ohos/hypium';
import {
  CardItemInfo,
  editModeManager,
  GridLayoutItemBuilder,
  GridLayoutItemInfo,
  AppItemInfo,
  FormRelationManager,
} from '@ohos/launchercommon';
import { FormStackAnimate } from '../../../../../main/ets/viewmodel/FormStackAnimate';
import { FormStackEvent } from '../../../../../main/ets/viewmodel/FormStackEvent';
import { FormStackTestUtil } from '../common/FormStackTestUtil';
import { FormStackManager } from '../../../../../main/ets/common/FormStackManager';
import { CheckEmptyUtils } from '@ohos/basicutils';
import { ResourceManager } from '@ohos/frameworkwrapper';
import { FormStackAnimateItem } from '../../../../../main/ets/viewmodel/FormStackAnimateItem';
import DataConvert from '@ohos/launchercommon/src/main/ets/transformdata/DataConvert';
import { FormStackUtil } from '../../../../../main/ets/common/FormStackUtil';
import { AddInterfaceExtendParam } from '../../../../../main/ets/viewmodel/FormStackViewModel';
import { relationalStore } from '@kit.ArkData';
import { FormStackExpandModel } from '../../../../../main/ets/common/FormStackExpandModel';
import { FormStackItemInfo } from '../../../../../main/ets/common/FormStackItemInfo';

export function FormStackEventTest() {
  describe('FormStackEventTest', () => {
    beforeAll(() => {
    });

    beforeEach(() => {
    });

    afterAll(() => {
    });

    afterEach(() => {
    });

    it('initData', 0, () => {
      const event: FormStackEvent = new FormStackEvent();
      const formStackInfo = FormStackTestUtil.createFormStackItemInfo(FormStackTestUtil.TEST_FORM_STACK_ID);
      const animate: FormStackAnimate = new FormStackAnimate();
      expect(event.initData(formStackInfo, [], animate)).assertFalse();
      expect(event.initData(formStackInfo, formStackInfo.layoutInfo[0], animate)).assertTrue();
    });

    it('resetData', 0, () => {
      const event: FormStackEvent = new FormStackEvent();
      const formStackInfo = FormStackTestUtil.createFormStackItemInfo(FormStackTestUtil.TEST_FORM_STACK_ID);
      const animate: FormStackAnimate = new FormStackAnimate();
      expect(event.initData(formStackInfo, formStackInfo.layoutInfo[0], animate)).assertTrue();
      expect(event.mFormItemList.length).assertEqual(formStackInfo.layoutInfo[0].length);

      event.resetData();
      expect(event.mFormItemList.length).assertEqual(0);
    });

    it('initEventMsg', 0, () => {
      const event: FormStackEvent = new FormStackEvent();
      const formStackInfo = FormStackTestUtil.createFormStackItemInfo(FormStackTestUtil.TEST_FORM_STACK_ID);
      expect(event.initData(formStackInfo, formStackInfo.layoutInfo[0], new FormStackAnimate())).assertTrue();

      if (!event.mDesktopContext) {
        expect(event.initEventMsg(event.mEventCallback)).assertFalse();
      } else {
        expect(event.initEventMsg(event.mEventCallback)).assertTrue();
      }
    });

    it('updateAppName', 0, () => {
      const event: FormStackEvent = new FormStackEvent();
      const formStackInfo = FormStackTestUtil.createFormStackItemInfo(FormStackTestUtil.TEST_FORM_STACK_ID);
      expect(event.initData(formStackInfo, formStackInfo.layoutInfo[0], new FormStackAnimate())).assertTrue();

      expect(event.updateAppName('111', '', '')).assertFalse();
      expect(event.updateAppName(formStackInfo.layoutInfo[0][0].cardId, '', '')).assertTrue();
      expect(event.updateAppName(formStackInfo.layoutInfo[0][event.mSlideFormIndex].cardId, 'new', 'menu'))
        .assertTrue();
    });

    it('syncFormItemList', 0, () => {
      const event: FormStackEvent = new FormStackEvent();
      const formStackInfo = FormStackTestUtil.createFormStackItemInfo(FormStackTestUtil.TEST_FORM_STACK_ID);
      expect(event.initData(formStackInfo, formStackInfo.layoutInfo[0], new FormStackAnimate())).assertTrue();

      expect(event.mFormItemList.length).assertEqual(3);
      event.syncFormItemList([new CardItemInfo(), new CardItemInfo()]);
      expect(event.mFormItemList.length).assertEqual(2);
    });

    it('getAppName', 0, () => {
      const event: FormStackEvent = new FormStackEvent();
      const formStackInfo = FormStackTestUtil.createFormStackItemInfo(FormStackTestUtil.TEST_FORM_STACK_ID);
      expect(event.initData(formStackInfo, formStackInfo.layoutInfo[0], new FormStackAnimate())).assertTrue();

      let mockKit = new MockKit();
      let mockFunc: Function =
        mockKit.mockFunc(ResourceManager.getInstance(), ResourceManager.getInstance().getAppNameWithCache);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(undefined);
      expect(event.getAppName({} as CardItemInfo, (name) => {
      })).assertTrue();
      expect(event.getAppName(formStackInfo.layoutInfo[0][0], (name) => {
      })).assertTrue();

      formStackInfo.layoutInfo[0][0].bundleName = 'com.ohos.suggestion';
      expect(event.getAppName(formStackInfo.layoutInfo[0][0], (name) => {
      })).assertTrue();

      formStackInfo.layoutInfo[0][0].bundleName = '';
      formStackInfo.layoutInfo[0][0].abilityName = 'ParentFormAbility';
      expect(event.getAppName(formStackInfo.layoutInfo[0][0], (name) => {
      })).assertTrue();

      formStackInfo.layoutInfo[0][0].bundleName = 'com.ohos.suggestion';
      event.getAppName(formStackInfo.layoutInfo[0][0], (name) => {
        expect(name).assertEqual('');
      });

      const card = formStackInfo.layoutInfo[0][0];
      card.abilityName = '';
      card.appLabelId = Number(card.cardId);
      card.cardName = 'appName';

      let cards: CardItemInfo[] =
        FormStackManager.getInstance().getFormStackSubCards(FormStackTestUtil.TEST_FORM_STACK_ID);
      cards.push(card);

      event.getAppName(card, (name) => {
        expect(name).assertEqual('appName');
      });

      mockKit.clear(ResourceManager.getInstance());
      mockKit.clearAll();
    });

    it('updateAppName', 0, () => {
      const event: FormStackEvent = new FormStackEvent();
      expect(event.updateAppName('', 'newName', 'currentName')).assertFalse();

      const formStackInfo = FormStackTestUtil.createFormStackItemInfo(FormStackTestUtil.TEST_FORM_STACK_ID);
      expect(event.initData(formStackInfo, formStackInfo.layoutInfo[0], new FormStackAnimate())).assertTrue();
      expect(event.updateAppName('1', 'newName', 'currentName')).assertTrue();

      event.mFormStackTopCardId = '1';
      expect(event.updateAppName('1', 'newName', 'newName')).assertTrue();
      expect(event.updateAppName('1', 'newName', 'currentName')).assertTrue();
    });

    it('onGestureJudgeBegin', 0, () => {
      const event: FormStackEvent = new FormStackEvent();
      const formStackInfo = FormStackTestUtil.createFormStackItemInfo(FormStackTestUtil.TEST_FORM_STACK_ID);
      expect(event.initData(formStackInfo, formStackInfo.layoutInfo[0], new FormStackAnimate())).assertTrue();

      const gestureInfo: GestureInfo = { type: GestureControl.GestureType.TAP_GESTURE, isSystemGesture: true };
      const gestureEvent: BaseGestureEvent = {
        fingerList: [],
        target: {
          area: {
            width: 0,
            height: 0,
            position: {},
            globalPosition: {}
          }
        },
        timestamp: 0,
        source: SourceType.Unknown,
        pressure: 0,
        tiltX: 0,
        tiltY: 0,
        sourceTool: SourceTool.Unknown
      };
      expect(event.onGestureJudgeBegin(gestureInfo, gestureEvent)).assertEqual(GestureJudgeResult.CONTINUE);

      let mockKit: MockKit = new MockKit();
      let inEditModeFunc: Function = mockKit.mockFunc(editModeManager, editModeManager.isInEditMode);
      when(inEditModeFunc)().afterReturn(false);
      gestureInfo.type = GestureControl.GestureType.DRAG;
      expect(event.onGestureJudgeBegin(gestureInfo, gestureEvent)).assertEqual(GestureJudgeResult.CONTINUE);

      let isDraggableFunc: Function = mockKit.mockFunc(editModeManager, editModeManager.isDraggable);
      when(isDraggableFunc)(ArgumentMatchers.any).afterReturn(true);
      when(inEditModeFunc)().afterReturn(true);
      expect(event.onGestureJudgeBegin(gestureInfo, gestureEvent)).assertEqual(GestureJudgeResult.CONTINUE);

      when(isDraggableFunc)(ArgumentMatchers.any).afterReturn(false);
      expect(event.onGestureJudgeBegin(gestureInfo, gestureEvent)).assertEqual(GestureJudgeResult.REJECT);

      mockKit.clear(editModeManager);
      mockKit.clearAll();
    });

    let event: FormStackEvent = new FormStackEvent();
    let expandModel: FormStackExpandModel = new FormStackExpandModel();
    let cardInfo: CardItemInfo = {
      id: 'a',
      container: 1,
      name: 'b',
      typeId: 0,
      cardId: 'c',
      bundleName: 'd',
      abilityName: 'e',
      moduleName: 'f',
      mainModuleName: 'g',
      cardName: 'h',
      cardDimension: 0,
      area: [1, 2, 3],
      description: 'aa',
      formConfigAbility: 'bb',
      appLabelId: 1,
      appName: 'cc',
      supportDimensions: [1, 2],
      page: 1,
      column: 1,
      row: 1,
      totleDimensionCount: 1,
      isTransparent: false,
      displayNameId: 0,
      dimension: 0,
      dragLayerWidth: 0,
      dragLayerHeight: 0,
      descriptionId: 0,
      showInCenter: false,
      renderingMode: 0,
      fromResultSet: (resultSet: relationalStore.ResultSet): CardItemInfo => {
        return new CardItemInfo();
      }
    } as CardItemInfo;
    expandModel.setCardInfo('123', cardInfo);
    let cardInfo1: CardItemInfo = {
      id: 'cardId',
    } as CardItemInfo;
    expandModel.setCardInfo('123', cardInfo);
    let cardInfo2: CardItemInfo = {
      id: 'cardId',
    } as CardItemInfo;
    expandModel.setCardInfo('123', cardInfo);
    let itemList: CardItemInfo[] = [cardInfo, cardInfo, cardInfo];
    let mFormStackItem: FormStackItemInfo = new FormStackItemInfo();
    let mFormStackAnimate: FormStackAnimate = new FormStackAnimate();
    let addInterfaceExtendParam: AddInterfaceExtendParam = {
      isNeedAnimate: false
    };
    let gridLayoutItemInfo: GridLayoutItemInfo = {
      bundleName: '',
      abilityName: '',
      appIconId: 0,
      negativeId: 0,
      isSelect: false,
      enterEditing: false,
      downloadProgress: 0,
      appStatus: undefined,
      iconResource: undefined,
      callerName: undefined,
      setInfo: (gridLayoutItemBuilder: GridLayoutItemBuilder): void => {
      },
      fillInfoWithAppItem: (appItem: AppItemInfo): GridLayoutItemInfo => {
        return new GridLayoutItemInfo();
      },
      toAppItemInfo: (): AppItemInfo => {
        return new AppItemInfo();
      }
    };
    let formStackAnimateItem: FormStackAnimateItem = new FormStackAnimateItem();
    let cards: GridLayoutItemInfo[] = [gridLayoutItemInfo, gridLayoutItemInfo, gridLayoutItemInfo];
    let viewList: FormStackAnimateItem[] = [formStackAnimateItem, formStackAnimateItem, formStackAnimateItem];

    it('initEventMsg_test03', 0, () => {
      let mocker: MockKit = new MockKit();
      let mockFunc = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.checkStrIsEmpty);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      event.initEventMsg(event.mEventCallback);
      expect(event).not().assertUndefined();
      mocker.clear(CheckEmptyUtils);
    });

    it('getAppName_test01', 0, () => {
      (event as object)['getAppName']();
      expect(event).not().assertUndefined();

      (event as object)['getAppName'](cardInfo);
      expect(event).not().assertUndefined();

      (event as object)['getAppName'](() => {
      });
      expect(event).not().assertUndefined();

      let mocker: MockKit = new MockKit();
      let mockFunc = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.checkStrIsEmpty);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      event.getAppName(cardInfo, () => {
      });
      expect(event).not().assertUndefined();
      mocker.clear(CheckEmptyUtils);
    });

    it('getAppName_test02', 0, () => {
      cardInfo.appLabelId = 1;
      cardInfo.bundleName = 'a';
      cardInfo.moduleName = 'a';
      let mocker: MockKit = new MockKit();
      let mockFunc = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.checkStrIsEmpty);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      event.getAppName(cardInfo, () => {
      });
      expect(event).not().assertUndefined();
      mocker.clear(CheckEmptyUtils);
    });

    it('syncFormItemList_test01', 0, () => {
      cardInfo.appLabelId = 1;
      cardInfo.bundleName = 'a';
      cardInfo.moduleName = 'a';
      let mocker: MockKit = new MockKit();
      let mockFunc = mocker.mockFunc(FormStackUtil, FormStackUtil.isInvalidFormStackList);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      event.syncFormItemList(itemList);
      expect(event).not().assertUndefined();
      mocker.clear(FormStackUtil);
    });

    it('onCreateFormStackAnimateEvent_test01', 0, () => {
      let mocker: MockKit = new MockKit();
      let mockFunc = mocker.mockFunc((event as object), (event as object)['isDataListEmpty']);
      when(mockFunc)().afterReturn(true);
      event.onCreateFormStackAnimateEvent();
      expect(event).not().assertUndefined();
      mocker.clear((event as object));
    });

    it('deleteFormFromStack_test01', 0, () => {
      mFormStackItem.formStackId = 'a';
      mFormStackItem.area = [1, 2, 3];
      event.mFormStackItem = mFormStackItem;
      let mocker: MockKit = new MockKit();
      let mockFunc =
        mocker.mockFunc(FormRelationManager.getInstance(), FormRelationManager.getInstance().isSceneBoardCard);
      let mockFunc1 = mocker.mockFunc((event as object), (event as object)['deleteFormFromStack']);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      when(mockFunc1)(ArgumentMatchers.any).afterReturnNothing;
      event.deleteFormFromStack(cardInfo);
      expect(event).not().assertUndefined();
      mocker.clear(FormRelationManager.getInstance());
      mocker.clear((event as object));
    });

    it('deleteFormFromStack_test02', 0, () => {
      mFormStackItem.formStackId = 'a';
      mFormStackItem.area = [1, 2, 3];
      event.mFormStackItem = mFormStackItem;
      let mocker: MockKit = new MockKit();
      let mockFunc =
        mocker.mockFunc(FormRelationManager.getInstance(), FormRelationManager.getInstance().isSceneBoardCard);
      let mockFunc1 = mocker.mockFunc((event as object), (event as object)['deleteFormFromStack']);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      when(mockFunc1)(ArgumentMatchers.any).afterReturnNothing;
      event.deleteFormFromStack(cardInfo);
      expect(event).not().assertUndefined();
      mocker.clear(DataConvert);
      mocker.clear((event as object));
    });

    it('getFormIfNeedCover_test01', 0, () => {
      event.mFormItemList = itemList;
      event.getFormIfNeedCover();
      expect(event).not().assertUndefined();

      let itemList1: CardItemInfo[] = [cardInfo, cardInfo]
      event.mFormItemList = itemList1;
      event.getFormIfNeedCover();
      expect(event).not().assertUndefined();
    });

    it('onFormStackChildLoad_test01', 0, () => {
      let mocker: MockKit = new MockKit();
      let mockFunc = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.checkStrIsEmpty);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      event.onFormStackChildLoad('a');
      expect(event).not().assertUndefined();
      mocker.clear(CheckEmptyUtils);
    });

    it('onFormStackChildLoad_test02', 0, () => {
      let mocker: MockKit = new MockKit();
      let mockFunc = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.checkStrIsEmpty);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      event.mFormStackTopCardId = 'a';
      event.onFormStackChildLoad('a');
      expect(event).not().assertUndefined();
      mocker.clear(CheckEmptyUtils);
    });

    it('onFormStackChildLoad_test03', 0, () => {
      let mocker: MockKit = new MockKit();
      let mockFunc = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.checkStrIsEmpty);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      event.mFormStackTopCardId = 'b';
      event.onFormStackChildLoad('a');
      expect(event).not().assertUndefined();
      mocker.clear(CheckEmptyUtils);
    });

    it('startFormsOpacityAnimate_test01', 0, () => {
      let mocker: MockKit = new MockKit();
      let mockFunc = mocker.mockFunc((event as object), (event as object)['isDataListEmpty']);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      (event as object)['startFormsOpacityAnimate'](0, 1, 1);
      expect(event).not().assertUndefined();
      mocker.clear((event as object));
    });

    it('onDeleteCardsEvent_test01', 0, () => {
      let mocker: MockKit = new MockKit();
      let mockFunc = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmptyArr);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      (event as object)['onDeleteCardsEvent'](['a', 'b', 'c'], true);
      expect(event).not().assertUndefined();
      mocker.clear(CheckEmptyUtils);
    });

    it('onDeleteCardsEvent_test02', 0, () => {
      let mocker: MockKit = new MockKit();
      let mockFunc = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmptyArr);
      let mockFunc1 = mocker.mockFunc((event as object), (event as object)['isAllCardsExistInFormList']);
      let mockFunc2 = mocker.mockFunc((event as object), (event as object)['deleteCardsWithNoAnimate']);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(false);
      when(mockFunc2)(ArgumentMatchers.any).afterReturnNothing;
      (event as object)['onDeleteCardsEvent'](['a', 'b', 'c'], false);
      expect(event).not().assertUndefined();
      mocker.clear(CheckEmptyUtils);
      mocker.clear((event as object));
    });

    it('onDeleteCardsEvent_test03', 0, () => {
      let mocker: MockKit = new MockKit();
      let mockFunc = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmptyArr);
      let mockFunc1 = mocker.mockFunc((event as object), (event as object)['isAllCardsExistInFormList']);
      let mockFunc2 = mocker.mockFunc((event as object), (event as object)['deleteCardsWithAnimate']);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(true);
      when(mockFunc2)(ArgumentMatchers.any).afterReturnNothing;
      (event as object)['onDeleteCardsEvent'](['a', 'b', 'c'], true);
      expect(event).not().assertUndefined();
      mocker.clear(CheckEmptyUtils);
      mocker.clear((event as object));
    });

    it('deleteCardsWithNoAnimate_test01', 0, () => {
      let mocker: MockKit = new MockKit();
      let mockFunc = mocker.mockFunc(FormStackUtil, FormStackUtil.isInvalidFormStackList);
      let mockFunc1 = mocker.mockFunc((event as object), (event as object)['deleteCardsOfFormList']);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      when(mockFunc1)(ArgumentMatchers.any).afterReturnNothing;
      (event as object)['deleteCardsWithNoAnimate'](['a', 'b', 'c']);
      expect(event).not().assertUndefined();
      mocker.clear(FormStackUtil);
      mocker.clear((event as object));
    });

    it('deleteCardsWithNoAnimate_test02', 0, () => {
      let mocker: MockKit = new MockKit();
      let mockFunc = mocker.mockFunc(FormStackUtil, FormStackUtil.isInvalidFormStackList);
      let mockFunc1 = mocker.mockFunc((event as object), (event as object)['deleteCardsOfFormList']);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      when(mockFunc1)(ArgumentMatchers.any).afterReturnNothing;
      (event as object)['deleteCardsWithNoAnimate'](['a', 'b', 'c']);
      expect(event).not().assertUndefined();
      mocker.clear(FormStackUtil);
      mocker.clear((event as object));
    });

    it('deleteCardsWithAnimate_test01', 0, () => {
      let mocker: MockKit = new MockKit();
      let mockFunc = mocker.mockFunc(FormStackUtil, FormStackUtil.isInvalidFormStackList);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      (event as object)['deleteCardsWithAnimate'](['a', 'b', 'c']);
      expect(event).not().assertUndefined();
      mocker.clear(FormStackUtil);
    });
  });
}