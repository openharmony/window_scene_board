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
  it,
  describe,
  expect,
  MockKit,
  when,
  ArgumentMatchers,
} from '@ohos/hypium';
import { CardItemInfo, FormRelationManager } from '@ohos/launchercommon/src/main/ets/TsIndex';
import { FormStackCommonInfo, FormStackItemEvent } from '../../../../../main/ets/viewmodel/FormStackItemEvent';
import { FormStackEventCb } from '../../../../../main/ets/common/FormStackEventCb';
import { FormStackAnimateItem } from '../../../../../main/ets/viewmodel/FormStackAnimateItem';
import { FormStackUtil } from '../../../../../main/ets/common/FormStackUtil';
import { CheckEmptyUtils } from '@ohos/basicutils';
import { scbEventExclusiveManager } from '@ohos/windowscene';
import { relationalStore } from '@kit.ArkData';

export function FormStackItemEventTest() {
  describe('FormStackItemEventTest', () => {
    beforeAll(() => {
    });

    beforeEach(() => {
    });

    afterAll(() => {
    });

    afterEach(() => {
    });

    it('initData', 0, () => {
      try {
        let event: FormStackItemEvent = new FormStackItemEvent();
        event.initData({
          formStackId: '',
          borderRadius: 1,
          cardItem: {} as CardItemInfo,
          eventCallback: {} as FormStackEventCb,
        }, {} as FormStackAnimateItem, () => {});
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    });

    it('resetData', 0, () => {
      let event: FormStackItemEvent = new FormStackItemEvent();
      event.resetData();
    });

    it('onError', 0, () => {
      try {
        let event: FormStackItemEvent = new FormStackItemEvent();
        let flag: boolean = false;
        event.initData({
          formStackId: '',
          borderRadius: 1,
          cardItem: {} as CardItemInfo,
          eventCallback: {
            onDeleteCardId: (cardId: string) => {
              flag = true;
            }
          } as FormStackEventCb,
        }, {} as FormStackAnimateItem, () => {});

        event.onError();
        expect(flag).assertTrue();

        flag = false;
        event.mEventCallback = undefined;
        event.onError();
        expect(flag).assertFalse();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    });

    it('onUninstall', 0, () => {
      try {
        let event: FormStackItemEvent = new FormStackItemEvent();
        let flag: boolean = false;
        let form: FormCallbackInfo = { id: 1, idString: '1' };
        event.initData({
          formStackId: '',
          borderRadius: 1,
          cardItem: {} as CardItemInfo,
          eventCallback: {
            onDeleteCardId: (cardId: string) => {
              flag = true;
            }
          } as FormStackEventCb,
        }, {} as FormStackAnimateItem, () => {});

        event.onUninstall(form);
        expect(flag).assertTrue();

        flag = false;
        event.mEventCallback = undefined;
        event.onUninstall(form);
        expect(flag).assertFalse();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    });

    it('onUpdateId', 0, () => {
      let mockKit: MockKit = new MockKit();
      try {
        let event: FormStackItemEvent = new FormStackItemEvent();
        let flag: boolean = false;
        event.initData({
          formStackId: '',
          borderRadius: 1,
          cardItem: {} as CardItemInfo,
          eventCallback: {
            onUpdateId: (card: CardItemInfo, cardId: string) => {
              flag = true;
            }
          } as FormStackEventCb,
        }, {} as FormStackAnimateItem, () => {});

        flag = false;
        let mockFunc: Function = mockKit.mockFunc(FormRelationManager.getInstance(), FormRelationManager.getInstance().isSceneBoardCard);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
        event.onUpdateId('1');
        expect(flag).assertFalse();

        flag = false;
        when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
        event.onUpdateId('1');
        expect(flag).assertTrue();

        flag = false;
        event.mCardItem = { cardId: '1' } as CardItemInfo;
        event.onUpdateId('1');
        expect(flag).assertFalse();

        flag = false;
        event.mCardItem = { cardId: '1', extend1: 'extend' } as CardItemInfo;
        event.onUpdateId('1');
        expect(flag).assertTrue();

        mockKit.clear(FormRelationManager.getInstance());
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mockKit.clearAll();
    });

    it('onClickForm', 0, () => {
      try {
        let event: FormStackItemEvent = new FormStackItemEvent();
        event.onClickForm();
        event.initData({
          formStackId: '',
          borderRadius: 1,
          cardItem: {
            area: [2, 2],
          } as CardItemInfo,
          eventCallback: {
            onUpdateId: (card: CardItemInfo, id: string) => {}
          } as FormStackEventCb,
        }, {} as FormStackAnimateItem, () => {});

        event.onClickForm();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    });

    it('onUpdateName', 0, () => {
      try {
        let event: FormStackItemEvent = new FormStackItemEvent();
        event.onUpdateName('');

        let flag: boolean = false;
        event.initData({
          formStackId: '',
          borderRadius: 1,
          cardItem: {
            area: [2, 2],
          } as CardItemInfo,
          eventCallback: {
            onUpdateName: (cardId: string, name: string) => {
              flag = true;
            }
          } as FormStackEventCb,
        }, {} as FormStackAnimateItem, () => {});

        event.onUpdateName('newName');
        expect(flag).assertTrue();

        event.initData({
          formStackId: '',
          borderRadius: 1,
          cardItem: {
            area: [2, 2],
          } as CardItemInfo,
          eventCallback: {
          } as FormStackEventCb,
        }, {} as FormStackAnimateItem, () => {});

        event.onUpdateName('newName');
        expect(flag).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    });

    it('onTouch', 0, () => {
      let mockKit: MockKit = new MockKit();
      try {
        let event: FormStackItemEvent = new FormStackItemEvent();
        event.onTouch({
          type: TouchType.Up,
        } as TouchEvent);

        event.onTouch({
          type: TouchType.Down,
        } as TouchEvent);
        let mockFunc: Function = mockKit.mockFunc(FormStackUtil, FormStackUtil.snapImage);
        when(mockFunc)(ArgumentMatchers.any).afterReturnNothing();

        event.initData({
          cardItem: { cardId: '1', bundleName: 'test_bundle' } as CardItemInfo,
        } as FormStackCommonInfo, new FormStackAnimateItem(), () => {});

        event.onTouch({
          type: TouchType.Down,
        } as TouchEvent);

        mockKit.clear(FormStackUtil);
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mockKit.clearAll();
    });

    let formStackItemEvent: FormStackItemEvent = new FormStackItemEvent();
    let event: TouchEvent = { type: TouchType.Down, } as TouchEvent;
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
    let mAnimateItem: FormStackAnimateItem = new FormStackAnimateItem();
    let mEventCallback: FormStackEventCb = {
      onUpdateId: (card: CardItemInfo, id: string): void => {
      },
      onUpdateName: (cardId: string, name: string): void => {
      },
      onDeleteCardId: (cardId: string): void => {
      },
      onIsAllowChangeOpacity: (): boolean => {
        return true;
      },
      onClearImages: (): void => {
      },
      onChildFormLoad: (cardId: string): void => {
      }
    }

    it('onTouch_test01', 0, () => {
      let mocker: MockKit = new MockKit();
      let mockFunc = mocker.mockFunc(scbEventExclusiveManager, scbEventExclusiveManager.isExclusive);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      formStackItemEvent.onTouch(event);
      expect(formStackItemEvent).not().assertUndefined();
      mocker.clear(scbEventExclusiveManager);
    });

    it('onTouch_test02', 0, () => {
      mAnimateItem.mOpacity = 0;
      formStackItemEvent.mCardItem = cardInfo;
      formStackItemEvent.mAnimateItem = mAnimateItem;
      let mocker: MockKit = new MockKit();
      let mockFunc = mocker.mockFunc(scbEventExclusiveManager, scbEventExclusiveManager.isExclusive);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      formStackItemEvent.onTouch(event);
      expect(formStackItemEvent).not().assertUndefined();
      mocker.clear(scbEventExclusiveManager);
    });

    it('onTouch_test03', 0, () => {
      let mocker: MockKit = new MockKit();
      try {
        mAnimateItem.mOpacity = 1;
        formStackItemEvent.mCardItem = cardInfo;
        formStackItemEvent.mAnimateItem = mAnimateItem;
        let mockFunc = mocker.mockFunc(scbEventExclusiveManager, scbEventExclusiveManager.isExclusive);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
        formStackItemEvent.onTouch(event);
        expect(formStackItemEvent).not().assertUndefined();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mocker.clear(scbEventExclusiveManager);
    });

    it('onLoadForm_test01', 0, () => {
      let mocker: MockKit = new MockKit();
      let mockFunc = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.checkStrIsEmpty);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      formStackItemEvent.onLoadForm('a');
      expect(formStackItemEvent).not().assertUndefined();
      mocker.clear(CheckEmptyUtils);
    });

    it('onLoadForm_test02', 0, () => {
      let mocker: MockKit = new MockKit();
      let mockFunc = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.checkStrIsEmpty);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      formStackItemEvent.onLoadForm('0');
      expect(formStackItemEvent).not().assertUndefined();
      mocker.clear(CheckEmptyUtils);
    });

    it('onLoadForm_test03', 0, () => {
      let mocker: MockKit = new MockKit();
      let mockFunc = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.checkStrIsEmpty);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      formStackItemEvent.onLoadForm('a');
      expect(formStackItemEvent).not().assertUndefined();
      mocker.clear(CheckEmptyUtils);
    });

    it('cacheSnapshotFormItem_test01', 0, () => {
      formStackItemEvent.mCardItem = cardInfo;
      let mocker: MockKit = new MockKit();
      let mockFunc = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.checkStrIsEmpty);
      let mockFunc1 = mocker.mockFunc(FormStackUtil, FormStackUtil.getFormComponentId);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn('a');
      (formStackItemEvent as object)['onLoadForm']();
      expect(formStackItemEvent).not().assertUndefined();
      mocker.clear(CheckEmptyUtils);
      mocker.clear(FormStackUtil);
    });

    it('cacheSnapshotFormItem_test02', 0, () => {
      formStackItemEvent.mCardItem = cardInfo;
      let mocker: MockKit = new MockKit();
      let mockFunc = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.checkStrIsEmpty);
      let mockFunc1 = mocker.mockFunc(FormStackUtil, FormStackUtil.getFormComponentId);
      let mockFunc2 = mocker.mockFunc(FormStackUtil, FormStackUtil.isValidImage);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn('a');
      when(mockFunc2)(ArgumentMatchers.any).afterReturn(true);
      (formStackItemEvent as object)['onLoadForm']();
      expect(formStackItemEvent).not().assertUndefined();
      mocker.clear(CheckEmptyUtils);
      mocker.clear(FormStackUtil);
    });

    it('cacheSnapshotFormItem_test03', 0, () => {
      formStackItemEvent.mCardItem = cardInfo;
      let mocker: MockKit = new MockKit();
      let mockFunc = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.checkStrIsEmpty);
      let mockFunc1 = mocker.mockFunc(FormStackUtil, FormStackUtil.getFormComponentId);
      let mockFunc2 = mocker.mockFunc(FormStackUtil, FormStackUtil.isValidImage);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn('a');
      when(mockFunc2)(ArgumentMatchers.any).afterReturn(false);
      (formStackItemEvent as object)['onLoadForm']();
      expect(formStackItemEvent).not().assertUndefined();
      mocker.clear(CheckEmptyUtils);
      mocker.clear(FormStackUtil);
    });

    it('onInactive_test01', 0, () => {
      formStackItemEvent.mCardItem = cardInfo;
      formStackItemEvent.mEventCallback = mEventCallback;
      let mocker: MockKit = new MockKit();
      let mockFunc = mocker.mockFunc((formStackItemEvent as object), (formStackItemEvent as object)['onClearImages']);
      let mockFunc1 = mocker.mockFunc(mEventCallback, mEventCallback['onIsAllowChangeOpacity']);
      when(mockFunc)(ArgumentMatchers.any).afterReturnNothing;
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(true);
      (formStackItemEvent as object)['onInactive']();
      expect(formStackItemEvent).not().assertUndefined();
      mocker.clear(mEventCallback);
      mocker.clear(mEventCallback);
    });

    it('onInactive_test02', 0, () => {
      formStackItemEvent.mCardItem = cardInfo;
      formStackItemEvent.mEventCallback = mEventCallback;
      let mocker: MockKit = new MockKit();
      let mockFunc = mocker.mockFunc((formStackItemEvent as object), (formStackItemEvent as object)['onClearImages']);
      let mockFunc1 = mocker.mockFunc(mEventCallback, mEventCallback['onIsAllowChangeOpacity']);
      when(mockFunc)(ArgumentMatchers.any).afterReturnNothing;
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(false);
      (formStackItemEvent as object)['onInactive']();
      expect(formStackItemEvent).not().assertUndefined();
      mocker.clear(mEventCallback);
      mocker.clear(mEventCallback);
    });
  });
}