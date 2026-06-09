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

import { afterAll, afterEach, beforeAll, beforeEach, describe, expect, it, MockKit, when } from '@ohos/hypium'
import { IntelligentCache } from '../../../../../../../main/ets/TsIndex';
import { image } from '@kit.ImageKit';

export function IntelligentCacheTest() {
  describe('IntelligentCacheTest', () => {
    beforeAll((): void => {
    })

    beforeEach((): void => {

    })

    afterEach((): void => {

    })

    afterAll((): void => {

    })

    it('IntelligentCacheTest_setIntelligentLaunchPage', 0, () => {
      IntelligentCache.getInstance().setIntelligentLaunchPage('123');
      let page = IntelligentCache.getInstance().getIntelligentLaunchPage();
      expect(page).assertEqual('123');
      expect(IntelligentCache.getInstance().getDoAnimFlag()).assertFalse();

      IntelligentCache.getInstance().setIntelligentLaunchPage(IntelligentCache.INTELLIGENT_SEARCH_PAGE);
      page = IntelligentCache.getInstance().getIntelligentLaunchPage();
      expect(page).assertEqual(IntelligentCache.INTELLIGENT_SEARCH_PAGE);
      expect(IntelligentCache.getInstance().getDoAnimFlag()).assertTrue();
    });

    it('IntelligentCacheTest_setDoAnimFlag', 0, () => {
      IntelligentCache.getInstance().setDoAnimFlag(true);
      expect(IntelligentCache.getInstance().getDoAnimFlag()).assertTrue();
      IntelligentCache.getInstance().setDoAnimFlag(false);
      expect(IntelligentCache.getInstance().getDoAnimFlag()).assertFalse();
      let closeFlag: boolean = false;
      IntelligentCache.getInstance().setAnimClose((needAnimate: boolean) => {
        closeFlag = true;
      });
      IntelligentCache.getInstance().setDoAnimFlag(false);
      expect(closeFlag).assertTrue();
    });

    it('IntelligentCacheTest_setAnimOpen', 0, () => {
      let openFlag: boolean = false;
      IntelligentCache.getInstance().setAnimOpen(() => {
        openFlag = true;
      });
      IntelligentCache.getInstance().doAnimOpen();
      expect(openFlag).assertTrue();
    });

    it('IntelligentCacheTest_setAnimClose', 0, () => {
      let closeFlag: boolean = false;
      IntelligentCache.getInstance().setAnimClose(() => {
        closeFlag = true;
      });
      IntelligentCache.getInstance().doAnimClose();
      expect(closeFlag).assertTrue();
    });

    it('IntelligentCacheTest_darkModeChange1', 0, () => {
      let flag: number = 1;
      IntelligentCache.getInstance().addIconListener('12345', () => {
        flag = flag + 1;
      });
      IntelligentCache.getInstance().darkModeChange('12345');
      expect(flag).assertEqual(2);

      IntelligentCache.getInstance().deleteIconListener('123');
      IntelligentCache.getInstance().deleteIconListener('12345');
      IntelligentCache.getInstance().darkModeChange('12345');
      expect(flag).assertEqual(2);
    });

    it('IntelligentCacheTest_darkModeChange2', 0, () => {
      let flag: number = 1;
      IntelligentCache.getInstance().addIconListener(undefined, undefined);
      IntelligentCache.getInstance().darkModeChange(undefined);
      expect(flag).assertEqual(1);

      IntelligentCache.getInstance().addIconListener(undefined, () => {
        flag = flag + 1;
      });
      IntelligentCache.getInstance().darkModeChange(undefined);
      expect(flag).assertEqual(1);

      IntelligentCache.getInstance().addIconListener('456', undefined);
      IntelligentCache.getInstance().darkModeChange('456');
      expect(flag).assertEqual(1);
    });

    it('IntelligentCacheTest_resetIntelligentScroll', 0, () => {
      let result: number = IntelligentCache.getInstance().resetIntelligentScroll();
      expect(result).assertEqual(0);

      IntelligentCache.getInstance().setResetIntelligentScroll(() => {
        return 1;
      });
      result = IntelligentCache.getInstance().resetIntelligentScroll();
      expect(result).assertEqual(1);
    });

    it('IntelligentCacheTest_getCardExpandViewOffsetY', 0, (iconId: string) => {
      iconId = 'Intelligent_StateMachine_CardStackExpand'
      let result: number = IntelligentCache.getInstance().getCardExpandViewOffsetY(iconId);
      expect(result).assertEqual(0);

      IntelligentCache.getInstance().setCardExpandViewScreenOffsetY(() => {
        return 1;
      });
      result = IntelligentCache.getInstance().getCardExpandViewOffsetY(iconId);
      expect(result).assertEqual(1);
    });

    it('IntelligentCacheTest_isCardExpandViewId', 0, () => {
      let isCardExpandViewId: boolean = IntelligentCache.getInstance().isCardExpandViewId('');
      expect(isCardExpandViewId).assertFalse();

      let isCurrentIconId2: boolean =
        IntelligentCache.getInstance().isCardExpandViewId('icon_id');
      expect(isCurrentIconId2).assertFalse();

      let isCurrentIconId3: boolean =
        IntelligentCache.getInstance().isCardExpandViewId(IntelligentCache.STATE_MACHINE_CARDSTACKEXPAND_ICON_ID);
      expect(isCurrentIconId3).assertTrue();
    });

    it('IntelligentCacheTest_isCurrentIconId1', 0, () => {
      let isCurrentIconId1: boolean = IntelligentCache.getInstance().isCurrentIconId('', null);
      expect(isCurrentIconId1).assertFalse();

      let isCurrentIconId2: boolean = IntelligentCache.getInstance().isCurrentIconId(null, 'icon_id');
      expect(isCurrentIconId2).assertFalse();
    });

    it('IntelligentCacheTest_isCurrentIconId2', 0, () => {
      let bundleName: string = 'com.dt.test';
      let iconKey: string = 'icon key';
      IntelligentCache.getInstance().setIconIdCache(bundleName, iconKey);
      let isCurrentIconId: boolean = IntelligentCache.getInstance().isCurrentIconId(bundleName, iconKey);
      expect(isCurrentIconId).assertTrue();

      IntelligentCache.getInstance().addIconById('Intelligent_StateMachine_111');
      isCurrentIconId = IntelligentCache.getInstance().isCurrentIconId(bundleName, 'Intelligent_StateMachine_111');
      expect(isCurrentIconId).assertTrue();

      IntelligentCache.getInstance().deleteIconById('Intelligent_StateMachine_111');
      isCurrentIconId = IntelligentCache.getInstance().isCurrentIconId(bundleName, 'Intelligent_StateMachine_111');
      expect(isCurrentIconId).assertFalse();
    });

    it('IntelligentCacheTest_setIconIdCache', 0, () => {
      IntelligentCache.getInstance().setIconIdCache(null, '');
      IntelligentCache.getInstance().setIconIdCache('', null);
      let iconKeyCached = IntelligentCache.getInstance().getIconIdCache(null);
      expect(iconKeyCached).assertUndefined();

      let bundleName: string = 'com.dt.setIconIdCache';
      let iconKey: string = 'icon key';
      IntelligentCache.getInstance().setIconIdCache(bundleName, iconKey);
      iconKeyCached = IntelligentCache.getInstance().getIconIdCache(bundleName);
      expect(iconKeyCached).assertEqual(iconKey);
    });

    it('IntelligentCacheTest_setAppSwitch', 0, () => {
      IntelligentCache.getInstance().setAppSwitch(false);
      expect(IntelligentCache.getInstance()['appSwitch']).assertFalse();
    })

    it('IntelligentCacheTest_isIntelligentPageOrIcon', 0, () => {
      let isIntelligentPageOrIcon: boolean = IntelligentCache.isIntelligentPageOrIcon(undefined);
      expect(isIntelligentPageOrIcon).assertFalse();

      let iconId: string = IntelligentCache.INTELLIGENT_PREFIX + 'icon';
      let isIntelligentPageOrIcon1: boolean =
        IntelligentCache.isIntelligentPageOrIcon(iconId, IntelligentCache.INTELLIGENT_BUNDLE);
      expect(isIntelligentPageOrIcon1).assertTrue();
    })

    it('IntelligentCacheTest_isStateMachinePage', 0, () => {
      let isStateMachinePage: boolean = IntelligentCache.isIntelligentCardPage('');
      expect(isStateMachinePage).assertFalse();

      isStateMachinePage = IntelligentCache.isIntelligentCardPage(IntelligentCache.STATE_MACHINE_DEFAULT_ICON_ID);
      expect(isStateMachinePage).assertTrue();
    })

    it('IntelligentCacheTest_isIntelligentCardPage', 0, () => {
      let isStateMachinePage: boolean = IntelligentCache.isIntelligentCardPage('');
      expect(isStateMachinePage).assertFalse();

      isStateMachinePage = IntelligentCache.isIntelligentCardPage(IntelligentCache.FEED_DEFAULT_ICON_ID);
      expect(isStateMachinePage).assertTrue();

      isStateMachinePage = IntelligentCache.isIntelligentCardPage(IntelligentCache.MY_PAGE_ICON_ID);
      expect(isStateMachinePage).assertTrue();

      isStateMachinePage = IntelligentCache.isIntelligentCardPage(IntelligentCache.INTELLIGENT_HEADERAREA_SCANBUTTON_ID);
      expect(isStateMachinePage).assertTrue();

      isStateMachinePage = IntelligentCache.isIntelligentCardPage(IntelligentCache.INTELLIGENT_GRIDSERVICE_CLICKMORE_ID);
      expect(isStateMachinePage).assertTrue();

      isStateMachinePage = IntelligentCache.isIntelligentCardPage(IntelligentCache.STATE_MACHINE_CARDSTACK_ICON_ID);
      expect(isStateMachinePage).assertTrue();

      isStateMachinePage = IntelligentCache.isIntelligentCardPage(IntelligentCache.STATE_MACHINE_CARDSTACKEXPAND_ICON_ID);
      expect(isStateMachinePage).assertTrue();

      isStateMachinePage = IntelligentCache.isIntelligentCardPage(IntelligentCache.INTELLIGENT_RECENTLY_USE_PREFIX + '123456');
      expect(isStateMachinePage).assertTrue();
    })

    it('IntelligentCacheTest_isIntelligentMyPage', 0, () => {
      let isStateMachinePage: boolean = IntelligentCache.isIntelligentMyPage();
      expect(isStateMachinePage).assertFalse();

      isStateMachinePage = IntelligentCache.isIntelligentMyPage(IntelligentCache.MY_PAGE_ICON_ID);
      expect(isStateMachinePage).assertTrue();
    })

    it('IntelligentCacheTest_isIntelligentScanIcon', 0, () => {
      let isStateMachinePage: boolean = IntelligentCache.isIntelligentScanIcon();
      expect(isStateMachinePage).assertFalse();

      isStateMachinePage = IntelligentCache.isIntelligentScanIcon(IntelligentCache.INTELLIGENT_HEADERAREA_SCANBUTTON_ID);
      expect(isStateMachinePage).assertTrue();
    })

    it('IntelligentCacheTest_isIntelligentClickMoreIcon', 0, () => {
      let isStateMachinePage: boolean = IntelligentCache.isIntelligentClickMoreIcon();
      expect(isStateMachinePage).assertFalse();

      isStateMachinePage = IntelligentCache.isIntelligentClickMoreIcon(IntelligentCache.INTELLIGENT_GRIDSERVICE_CLICKMORE_ID);
      expect(isStateMachinePage).assertTrue();
    })

    it('IntelligentCacheTest_isIntelligentFeaturedServicesId1', 0, () => {
      let isIntelligentFeaturedServicesId: boolean = IntelligentCache.isIntelligentFeaturedServicesId();
      expect(isIntelligentFeaturedServicesId).assertFalse();
    })

    it('IntelligentCacheTest_isIntelligentFeaturedServicesId2', 0, () => {
      let icon: string = IntelligentCache.INTELLIGENT_FA_PREFIX + 'icon';
      let isIntelligentFeaturedServicesId: boolean = IntelligentCache.isIntelligentFeaturedServicesId(icon);
      expect(isIntelligentFeaturedServicesId).assertTrue();

      icon = IntelligentCache.INTELLIGENT_RECENTLY_USE_PREFIX + 'icon';
      isIntelligentFeaturedServicesId = IntelligentCache.isIntelligentFeaturedServicesId(icon);
      expect(isIntelligentFeaturedServicesId).assertTrue();
    })

    it('IntelligentCacheTest_isIntelligentIconInScreen', 0, () => {
      let isIntelligentIconInScreen: boolean = IntelligentCache.getInstance().isIntelligentIconInScreen(undefined);
      expect(isIntelligentIconInScreen).assertFalse();

      IntelligentCache.getInstance().setAppSwitch(false);
      isIntelligentIconInScreen = IntelligentCache.getInstance().isIntelligentIconInScreen('icon id');
      expect(isIntelligentIconInScreen).assertFalse();

      IntelligentCache.getInstance().setAppSwitch(true);
      isIntelligentIconInScreen = IntelligentCache.getInstance().isIntelligentIconInScreen('iconKey');
      expect(isIntelligentIconInScreen).assertTrue();
    })

    it('IntelligentCacheTest_setIconCache', 0, async (done: Function) => {
      IntelligentCache.getInstance().setIconCache(null, null);

      let image: image.PixelMap = await resourceManagerCreateImage();
      let iconKey = 'image_key';
      IntelligentCache.getInstance().setIconCache(null, image);
      expect(IntelligentCache.getInstance().getIconCache(iconKey)).assertUndefined();

      IntelligentCache.getInstance().setIconCache(iconKey, image);
      expect(IntelligentCache.getInstance().getIconCache(iconKey)).not().assertUndefined();
      IntelligentCache.getInstance().deleteIconCache(iconKey);
      done();
    })

    it('IntelligentCacheTest_setRecentlyIconCache', 0, async (done: Function) => {
      IntelligentCache.getInstance().setRecentlyIconCache(null, null);

      let image: image.PixelMap = await resourceManagerCreateImage();
      let iconKey = 'setRecentlyIconCache_key';
      IntelligentCache.getInstance().setRecentlyIconCache(null, image);
      expect(IntelligentCache.getInstance().getIconCache(iconKey)).assertUndefined();

      IntelligentCache.getInstance().setRecentlyIconCache(iconKey, image);
      expect(IntelligentCache.getInstance().getIconCache(iconKey)).not().assertUndefined();
      IntelligentCache.getInstance().deleteIconCache(iconKey);
      done();
    })

    it('IntelligentCacheTest_getIconCache', 0, () => {
      let key: string = '';
      let cache: image.PixelMap | undefined = IntelligentCache.getInstance().getIconCache(key);
      expect(cache).assertUndefined();
    })

    it('IntelligentCacheTest_clearAllCache', 0, () => {
      IntelligentCache.getInstance().clearAllCache();
      expect(IntelligentCache.getInstance()['iconCacheMap'].length).assertEqual(0);
    })

    it('IntelligentCacheTest_deleteIconCache', 0, () => {
      IntelligentCache.getInstance().deleteIconCache('');
      expect(IntelligentCache.getInstance()['iconCacheMap']).not().assertNull();
    })

    it('IntelligentCacheTest_deleteRecentlyIconCache', 0, () => {
      IntelligentCache.getInstance().deleteRecentlyIconCache('');
      expect(IntelligentCache.getInstance()['iconCacheMap']).not().assertNull();
    })

    it('IntelligentCacheTest_deleteIconIdCacheByFormId', 0, () => {
      IntelligentCache.getInstance().deleteIconIdCacheByFormId('');
      IntelligentCache.getInstance().deleteIconIdCacheByFormId(IntelligentCache.STATE_MACHINE_DEFAULT_ICON_ID);
      IntelligentCache.getInstance().setIconIdCache(IntelligentCache.INTELLIGENT_SEARCH_PAGE, IntelligentCache.FEED_DEFAULT_ICON_ID);
      IntelligentCache.getInstance().setIconIdCache(IntelligentCache.INTELLIGENT_BUNDLE, IntelligentCache.STATE_MACHINE_DEFAULT_ICON_ID);
      IntelligentCache.getInstance().deleteIconIdCacheByFormId(IntelligentCache.STATE_MACHINE_DEFAULT_ICON_ID);
      expect(IntelligentCache.getInstance().getIconIdCache(IntelligentCache.INTELLIGENT_BUNDLE)).assertNull();
    })
  });
}

async function resourceManagerCreateImage(): Promise<image.PixelMap> {
  let width: number = 10;
  let height: number = 10;
  const color = new ArrayBuffer(width * height * 4);
  let opts: image.InitializationOptions = { editable: true, pixelFormat: 3, size: { height: width, width: height } };
  return image.createPixelMap(color, opts);
}