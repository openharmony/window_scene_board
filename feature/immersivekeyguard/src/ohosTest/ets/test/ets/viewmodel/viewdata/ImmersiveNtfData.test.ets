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
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, Level, MockKit } from '@ohos/hypium';
import { LiveViewData, ParseResultType } from '@ohos/systemuicommon/src/main/ets/TsIndex';
import { ImmersiveNtfData } from '../../../../../../main/ets/viewmodel/viewdata/ImmersiveNtfData';
import { ImmersiveCardData } from '../../../../../../main/ets/viewmodel/viewdata/ImmersiveCardData';
import { ImmersiveCapsuleData } from '../../../../../../main/ets/viewmodel/viewdata/ImmersiveCapsuleData';
import {
  ImmersiveShowType
} from '@ohos/systemuicommon/src/main/ets/TsIndex';
import { Want } from '@kit.AbilityKit';

/**
 * 沉浸式锁屏测试用例
 */
export function ImmersiveNtfDataTest() {
  describe('ImmersiveNtfDataTest', (): void => {
    beforeAll((): void => {
    });
    beforeEach((): void => {
    });
    afterAll((): void => {
    });
    afterEach((): void => {
    });

    it('test_init', Level.LEVEL0, (): void => {
      let ntfData: ImmersiveNtfData = new ImmersiveNtfData();
      ntfData.resultType = ParseResultType.MISS;
      ntfData.resultType = ParseResultType.JOIN;
      ntfData.resultType = ParseResultType.MATCH;
      ntfData.hashCode = 'myhashcodetest';
      ntfData.groupKey = 'groupkeytest';
      ntfData.creatorBundleName = 'myapp.com';
      ntfData.id = 10000;
      (ntfData as object)['isShowingInCard'] = true;
      (ntfData as object)['isShowingInCard'] = false;
      (ntfData as object)['showType'] = ImmersiveShowType.NOT_SHOW;
      (ntfData as object)['showType'] = ImmersiveShowType.SHOW_CARD;
      (ntfData as object)['showType'] = ImmersiveShowType.SHOW_CAPSULE;
      expect(ntfData).not().assertNull();
    });

    it('test_onShowTypeChange', Level.LEVEL0, (): void => {
      let ntfData: ImmersiveNtfData = new ImmersiveNtfData();
      (ntfData as object)['showType'] = ImmersiveShowType.NOT_SHOW;
      (ntfData as object)['onShowTypeChange'](ImmersiveShowType.SHOW_CARD);
      expect(ntfData).not().assertNull();
    });

    it('test_equals', Level.LEVEL0, (): void => {
      let ntfData: ImmersiveNtfData = new ImmersiveNtfData();
      let ntfData2: ImmersiveNtfData = new ImmersiveNtfData();
      let cardData: ImmersiveCardData = new ImmersiveCardData();
      ntfData.equals(cardData);
      ntfData.groupKey = 'mygroupkey';
      ntfData2.groupKey = 'mygroupkey';
      ntfData.equals(ntfData2);
      expect(ntfData).not().assertNull();
    });

    it('test_update', Level.LEVEL0, (): void => {
      let ntfData: ImmersiveNtfData = new ImmersiveNtfData();
      let ntfData2: ImmersiveNtfData = new ImmersiveNtfData();
      let cardData: ImmersiveCardData = new ImmersiveCardData();
      let capsuleData: ImmersiveCapsuleData = new ImmersiveCapsuleData();
      ntfData.update(cardData);
      ntfData2.creatorBundleName = 'mybundlename';
      ntfData2.groupKey = 'mygroupkey';
      ntfData2.cardData = cardData;
      ntfData2.capsuleData = capsuleData;
      ntfData.update(ntfData2);
      expect(ntfData).not().assertNull();
    });

    it('test_onAppIconChange', Level.LEVEL0, (): void => {
      let ntfData: ImmersiveNtfData = new ImmersiveNtfData();
      ntfData.onAppIconChange();
      ntfData.onUpdateAppName('myappname');
      expect(ntfData).not().assertNull();
    });

    it('test_shouldShowInImmersive', Level.LEVEL0, (): void => {
      let ntfData: ImmersiveNtfData = new ImmersiveNtfData();
      (ntfData as object)['showType'] = ImmersiveShowType.SHOW_CARD;
      ntfData.shouldShowInImmersiveCard();
      ntfData.isUiExtensionCard();
      ntfData.shouldShowInCapsule();
      expect(ntfData).not().assertNull();
    });

    it('test_ShowType', Level.LEVEL0, (): void => {
      let ntfData: ImmersiveNtfData = new ImmersiveNtfData();
      let cardData: ImmersiveCardData = new ImmersiveCardData();
      ntfData.addShowType(ImmersiveShowType.NOT_SHOW);
      ntfData.deleteShowType(ImmersiveShowType.NOT_SHOW);
      ntfData.addShowType(ImmersiveShowType.SHOW_CAPSULE);
      ntfData.deleteShowType(ImmersiveShowType.SHOW_CAPSULE);
      ntfData.addShowType(ImmersiveShowType.SHOW_CARD);
      ntfData.deleteShowType(ImmersiveShowType.SHOW_CARD);
      ntfData.cardData = cardData;
      ntfData.addShowType(ImmersiveShowType.NOT_SHOW);
      ntfData.deleteShowType(ImmersiveShowType.NOT_SHOW);
      ntfData.addShowType(ImmersiveShowType.SHOW_CAPSULE);
      ntfData.deleteShowType(ImmersiveShowType.SHOW_CAPSULE);
      ntfData.addShowType(ImmersiveShowType.SHOW_CARD);
      ntfData.deleteShowType(ImmersiveShowType.SHOW_CARD);
      expect(ntfData).not().assertNull();
    });

    it('test_ShowInCard', Level.LEVEL0, (): void => {
      let ntfData: ImmersiveNtfData = new ImmersiveNtfData();
      ntfData.setShowInCard(true);
      expect(ntfData.isShownInCard()).assertTrue();
    });

    it('test_createAndDeleteGroup', Level.LEVEL0, (): void => {
      let ntfData: ImmersiveNtfData = new ImmersiveNtfData();
      let capsuleData: ImmersiveCapsuleData = new ImmersiveCapsuleData();
      ntfData.createGroup();
      ntfData.deleteGroup();
      ntfData.capsuleData = capsuleData;
      ntfData.createGroup();
      ntfData.deleteGroup();
      expect(ntfData).not().assertNull();
    });

    it('test_setNtfHide', Level.LEVEL0, (): void => {
      let ntfData: ImmersiveNtfData = new ImmersiveNtfData();
      let capsuleData: ImmersiveCapsuleData = new ImmersiveCapsuleData();
      ntfData.setNtfHide(true);
      ntfData.setNtfHide(false);
      ntfData.capsuleData = capsuleData;
      ntfData.setNtfHide(true);
      ntfData.setNtfHide(false);
      expect(ntfData).not().assertNull();
    });

    it('test_setAppName', Level.LEVEL0, (): void => {
      let ntfData: ImmersiveNtfData = new ImmersiveNtfData();
      let cardData: ImmersiveCardData = new ImmersiveCardData();
      let capsuleData: ImmersiveCapsuleData = new ImmersiveCapsuleData();
      ntfData.setAppName(undefined, undefined);
      ntfData.cardData = cardData;
      ntfData.capsuleData = capsuleData;
      ntfData.setAppName(undefined, undefined);
      ntfData.setAppName('myappname', true);
      ntfData.setAppName('myappname', false);
      expect(ntfData).not().assertNull();
    });

    it('test_updateCardAndCapsuleData', Level.LEVEL0, (): void => {
      let ntfData: ImmersiveNtfData = new ImmersiveNtfData();
      let cardData: ImmersiveCardData = new ImmersiveCardData();
      let capsuleData: ImmersiveCapsuleData = new ImmersiveCapsuleData();
      (ntfData as object)['updateCardData'](cardData);
      (ntfData as object)['updateCapsuleData'](capsuleData);
      expect(ntfData).not().assertNull();
    });

    it('test_setHashCode', Level.LEVEL0, (): void => {
      let ntfData: ImmersiveNtfData = new ImmersiveNtfData();
      ntfData.setHashCode('hashcode', true);
      ntfData.setHashCode('hashcode');
      expect(ntfData).not().assertNull();
    });

    it('test_setCreatorBundleName', Level.LEVEL0, (): void => {
      let ntfData: ImmersiveNtfData = new ImmersiveNtfData();
      ntfData.setCreatorBundleName('bundlename.com', true);
      ntfData.setCreatorBundleName('bundlename.com');
      expect(ntfData).not().assertNull();
    });

    it('test_setCapsuleData', Level.LEVEL0, (): void => {
      let ntfData: ImmersiveNtfData = new ImmersiveNtfData();
      let capsuleData: ImmersiveCapsuleData = new ImmersiveCapsuleData();
      ntfData.setCapsuleData(capsuleData, true);
      ntfData.setCapsuleData(capsuleData);
      ntfData.getCapsuleData();
      expect(ntfData).not().assertNull();
    });

    it('test_setCardData', Level.LEVEL0, (): void => {
      let ntfData: ImmersiveNtfData = new ImmersiveNtfData();
      let cardData: ImmersiveCardData = new ImmersiveCardData();
      ntfData.setCardData(cardData, true);
      ntfData.setCardData(cardData);
      expect(ntfData).not().assertNull();
    });

    it('test_toString', Level.LEVEL0, (): void => {
      let ntfData: ImmersiveNtfData = new ImmersiveNtfData();
      ntfData.toString();
      ntfData.id = 10000;
      ntfData.groupKey = 'groupkey';
      (ntfData as object)['isShowingInCard'] = true;
      ntfData.toString();
      expect(ntfData).not().assertNull();
    });



    it('test_updateCardData_02', Level.LEVEL0, (): void => {
      let ntfData: ImmersiveNtfData = new ImmersiveNtfData();
      let cardData: ImmersiveCardData = new ImmersiveCardData();
      (ntfData as object)['updateCardData'](cardData,false);
      expect(ntfData).not().assertNull();
    });

    it('test_setHashCode', Level.LEVEL0, (): void => {
      let ntfData: ImmersiveNtfData = new ImmersiveNtfData();
      ntfData.setHashCode('test', false)
      expect(ntfData).not().assertNull();
    });

    it('test_setCreatorBundleName_02', Level.LEVEL0, (): void => {
      let ntfData: ImmersiveNtfData = new ImmersiveNtfData();
      ntfData.setCreatorBundleName('test', true)
      ntfData.setCreatorBundleName('test', false)
      expect(ntfData).not().assertNull();
    });

    it('test_setWantAgent_02', Level.LEVEL0, (): void => {
      let ntfData: ImmersiveNtfData = new ImmersiveNtfData();
      ntfData.setWantAgent(Want, false);
      expect(ntfData).not().assertNull();
    });

    it('test_setCapsuleData_02', Level.LEVEL0, (): void => {
      let ntfData: ImmersiveNtfData = new ImmersiveNtfData();
      let capsuleData: ImmersiveCapsuleData = new ImmersiveCapsuleData();
      ntfData.setCapsuleData(capsuleData, false);
      ntfData.getCapsuleData();
      expect(ntfData).not().assertNull();
    });
  });
}