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
} from '@ohos/hypium';
import {
  CommonConstants,
  GridLayoutItemInfo,
  RdbStoreManager,
} from '@ohos/launchercommon';
import {
  AiSuggestionFormManager,
} from '../../../../../../main/ets/default/manager/AiSuggestionFormManager';
import { LauncherCardInfo } from '../../../../../../main/ets/default/bean/LauncherCardInfo';
import { LauncherDisplayCardInfo } from '@ohos/launchercommon/src/main/ets/aisuggestion/LauncherDisplayCardInfo';
import { LauncherRecItem } from '@ohos/launchercommon/src/main/ets/aisuggestion/LauncherRecItem';

export function AiSuggestionFormManagerTest() {
  describe('AiSuggestionFormManagerTest', (): void => {
    const cardId = '12345';

    beforeAll((): void => {
    });

    beforeEach((): void => {
      AiSuggestionFormManager.getInstance().deleteCardInfoAfterAnimation(cardId);
    });

    afterAll((): void => {
    });

    afterEach((): void => {
      AiSuggestionFormManager.getInstance().deleteCardInfoAfterAnimation(cardId);
    });

    it('testRegisterCallback', 0, (): void => {
      let called: boolean = false;

      const cardInfo = new LauncherCardInfo();
      cardInfo.recId = '123';
      AiSuggestionFormManager.getInstance().updateCardInfo('0', cardInfo);
      expect(called).assertFalse();

      called = false;
      let called1: boolean = false;
      AiSuggestionFormManager.getInstance().updateCardInfo(cardId, cardInfo);
      expect(called).assertTrue();
      expect(called1).assertTrue();

    });

    it('testUnregisterCallback', 0, (): void => {
      let called: boolean = false;
      // 没有注册回调函数时调用取消注册接口
      const cardInfo = new LauncherCardInfo();
      cardInfo.recId = '123';
      AiSuggestionFormManager.getInstance().updateCardInfo(cardId, cardInfo);
      expect(called).assertFalse();
    });

    it('testInitVoiceCardInfo', 0, async (done: Function): Promise<void> => {
      let layoutInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      expect(AiSuggestionFormManager.getInstance().initVoiceCardInfo(layoutInfo));
      done();
    });

    it('testUpdateVoiceCardId', 0, (): void => {
      AiSuggestionFormManager.getInstance().updateVoiceCardId('', '456');

      let called: boolean = false;
      const oldCardId: string = '123';
      const mocker: MockKit = new MockKit();
      const mockDeleteVoiceCard: Function =
        mocker.mockFunc(RdbStoreManager.getInstance(), RdbStoreManager.getInstance().deleteVoiceCardInfoByCardId);
      when(mockDeleteVoiceCard)(oldCardId).afterAction(() => {
        called = true;
      });
      AiSuggestionFormManager.getInstance().updateVoiceCardId(oldCardId, '456');
      expect(called).assertTrue();

      mocker.clear(RdbStoreManager.getInstance());
      mocker.clearAll();
    });

    it('testUpdateCardInfo', 0, (): void => {
      const cardInfo = new LauncherCardInfo();
      cardInfo.recId = '123';

      AiSuggestionFormManager.getInstance().deleteCardInfoAfterAnimation(cardId);
      expect(AiSuggestionFormManager.getInstance().getCardInfo(cardId)).assertUndefined();

      // 测试AiSuggestionFormCallback未注册时不会更新推荐内容
      AiSuggestionFormManager.getInstance().updateCardInfo(cardId, cardInfo);
      expect(AiSuggestionFormManager.getInstance().getCardInfo(cardId)).assertUndefined();

      // 测试AiSuggestionFormCallback注册后可以更新推荐内容
      AiSuggestionFormManager.getInstance().updateCardInfo(cardId, cardInfo);
      expect(AiSuggestionFormManager.getInstance().getCardInfo(cardId)?.recId).assertEqual('123');

      // 测试setRectItemCardId逻辑分支
      // 无法测试undefined的场景，ets编译会检查类型，编译会报错
      AiSuggestionFormManager.getInstance().updateCardInfo(cardId, cardInfo);
      expect(AiSuggestionFormManager.getInstance().getCardInfo(cardId)?.recId).assertEqual('123');

      cardInfo.portrait = new LauncherDisplayCardInfo();
      cardInfo.portrait.recItems = [];
      const rectItem: LauncherRecItem = new LauncherRecItem();
      cardInfo.portrait.recItems.push(rectItem);
      AiSuggestionFormManager.getInstance().updateCardInfo(cardId, cardInfo);
      expect(AiSuggestionFormManager.getInstance().getCardInfo(cardId)?.recId).assertEqual('123');
      // 清理测试数据
      AiSuggestionFormManager.getInstance().deleteCardInfoAfterAnimation(cardId);
    });

    it('testDeleteCardInfo', 0, (): void => {
      AiSuggestionFormManager.getInstance().deleteCardInfo('0');
    });

    it('testResetCard', 0, (): void => {
      AiSuggestionFormManager.getInstance().resetCard('0');
      const cardId1 = '123456';
      const cardInfo = new LauncherCardInfo();
      const recId = '123';
      cardInfo.recId = recId;

      AiSuggestionFormManager.getInstance().updateCardInfo(cardId, cardInfo);
      AiSuggestionFormManager.getInstance().updateCardInfo(cardId1, cardInfo);
      AiSuggestionFormManager.getInstance().resetCardInfo(cardId);
      expect(AiSuggestionFormManager.getInstance().getCardInfo(cardId)).assertUndefined();

      // 用例完成后清理此次用例产生的数据
      AiSuggestionFormManager.getInstance().resetCardInfo(cardId1);
    });

    it('testResetCardInfo', 0, (): void => {
      AiSuggestionFormManager.getInstance().resetCardInfo('0');
    });

    it('testGetAllCardInfoCache', 0, (): void => {
      expect(AiSuggestionFormManager.getInstance().getAllCardInfoCache()).not().assertNull();
    });

    it('testGetCardInfo', 0, (): void => {
      const recId1 = '123';
      const cardInfo1 = new LauncherCardInfo();
      cardInfo1.recId = recId1;

      let cardInfo: LauncherCardInfo | undefined = AiSuggestionFormManager.getInstance().getCardInfo(cardId);
      expect(cardInfo).assertUndefined();


      AiSuggestionFormManager.getInstance().updateCardInfo(cardId, cardInfo1);
      cardInfo = AiSuggestionFormManager.getInstance().getCardInfo(cardId);
      expect(cardInfo?.recId).assertUndefined();

      // 清理测试数据
      AiSuggestionFormManager.getInstance().deleteCardInfoAfterAnimation(cardId);
    });

    it('AbilityFormUtilTest_updateSubCardId_01', 0, (): void => {
      const recItem = new LauncherRecItem();
      recItem.itemType === CommonConstants.TYPE_CARD;
      recItem.abilityName === 'ParentFormAbility';
      recItem.dimension === CommonConstants.CARD_DIMENSION_2x2;
      const cardInfo = new LauncherCardInfo();
      const portrait: LauncherDisplayCardInfo = new LauncherDisplayCardInfo();
      portrait.recItems = [recItem];

      let mocker: MockKit = new MockKit();
      let manager: AiSuggestionFormManager = AiSuggestionFormManager.getInstance();
      const func: Function = mocker.mockFunc(manager, manager.getCardInfo);
      when(func)().afterReturn(cardInfo);
      AiSuggestionFormManager.getInstance().updateSubCardId('', recItem, '24');
      expect(recItem.cardId).assertUndefined();

      mocker.clear(manager);
      mocker.clearAll();
    });

    it('AbilityFormUtilTest_updateSubCardId_02', 0, (): void => {
      const recItem1 = new LauncherRecItem();
      recItem1.itemType === CommonConstants.TYPE_CARD;
      recItem1.abilityName === 'TestFormAbility';
      recItem1.dimension === CommonConstants.CARD_DIMENSION_2x4;
      const cardInfo = new LauncherCardInfo();
      const portrait: LauncherDisplayCardInfo = new LauncherDisplayCardInfo();
      portrait.recItems = [recItem1];

      let mocker: MockKit = new MockKit();
      let manager: AiSuggestionFormManager = AiSuggestionFormManager.getInstance();
      const func: Function = mocker.mockFunc(manager, manager.getCardInfo);
      when(func)().afterReturn(cardInfo);
      AiSuggestionFormManager.getInstance().updateSubCardId('123', new LauncherRecItem(), '24');
      expect(recItem1.cardId).assertUndefined();

      mocker.clear(manager);
      mocker.clearAll();
    });

    it('AbilityFormUtilTest_updateSubCardId_03', 0, (): void => {
      const cardInfo = new LauncherCardInfo();
      const portraitRecItem = new LauncherRecItem();
      portraitRecItem.itemType === CommonConstants.TYPE_CARD;
      portraitRecItem.abilityName === 'ParentFormAbility';
      portraitRecItem.dimension === CommonConstants.CARD_DIMENSION_2x2;
      portraitRecItem.cardId = '24';
      const portraitCardInfo: LauncherDisplayCardInfo = new LauncherDisplayCardInfo();
      portraitCardInfo.recItems = [portraitRecItem];

      const landScapeRecItem = new LauncherRecItem();
      landScapeRecItem.itemType === CommonConstants.TYPE_CARD;
      landScapeRecItem.abilityName === 'ParentFormAbility';
      landScapeRecItem.dimension === CommonConstants.CARD_DIMENSION_2x2;
      const landscapeCardInfo: LauncherDisplayCardInfo = new LauncherDisplayCardInfo();
      landscapeCardInfo.recItems = [landScapeRecItem];

      let mocker: MockKit = new MockKit();
      let manager: AiSuggestionFormManager = AiSuggestionFormManager.getInstance();
      const func: Function = mocker.mockFunc(manager, manager.getCardInfo);
      when(func)('123').afterReturn(cardInfo);
      AiSuggestionFormManager.getInstance().updateSubCardId('123', portraitRecItem, '24');
      expect(portraitRecItem.cardId).assertEqual('24');

      mocker.clear(manager);
      mocker.clearAll();
    });
  });
}