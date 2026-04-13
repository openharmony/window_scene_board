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
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, Level } from '@ohos/hypium';
import { NotificationEntry } from '@ohos/notificationcomponent/src/main/ets/model/NotificationEntry';
import { NotificationAnimationParas } from '@ohos/notificationcomponent/src/main/ets/common/NotificationAnimationParas';
import { ImmersiveAnimScene } from '../../../../../../main/ets/common/anim/ImmersiveAnimConstants';
import { AnimStyleType } from '../../../../../../main/ets/model/data/anim/ImmersiveAnimStyle';
import { ImmersiveListAnimManager, ListAnimParas } from '../../../../../../main/ets/viewmodel/viewanim/ImmersiveListAnimManager';
import { NotificationEntryArray } from '../../../../../../main/ets/viewmodel/viewdata/NotificationEntryArray';
import { NtfListStaticState } from '../../../../../../main/ets/viewmodel/viewdata/NtfListState';

/**
 * 沉浸式锁屏测试用例
 */
export function ImmersiveListAnimManagerTest() {
  describe('ImmersiveListAnimManagerTest', (): void => {
    beforeAll((): void => {
    });
    beforeEach((): void => {
    });
    afterAll((): void => {
    });
    afterEach((): void => {
    });

    it('test_setChildViewArea', Level.LEVEL0, (): void => {
      let manager = new ImmersiveListAnimManager();
      manager.setChildViewArea('1');
      expect(manager).not().assertNull();
    });

    it('test_getStartIndex', Level.LEVEL0, (): void => {
      let manager: ImmersiveListAnimManager = new ImmersiveListAnimManager();
      manager.getStartIndex();

      manager.setListStaticState(new NtfListStaticState());
      manager.getStartIndex();
      expect(manager).not().assertNull();
    });

    it('test_getEndIndex', Level.LEVEL0, (): void => {
      let manager: ImmersiveListAnimManager = new ImmersiveListAnimManager();
      manager.getEndIndex();

      manager.setListStaticState(new NtfListStaticState());
      manager.getEndIndex();
      expect(manager).not().assertNull();
    });

    it('test_getListData', Level.LEVEL0, (): void => {
      let manager: ImmersiveListAnimManager = new ImmersiveListAnimManager();
      manager.getListData();
      expect(manager).not().assertNull();
    });

    it('test_getItemHashcode', Level.LEVEL0, (): void => {
      let manager: ImmersiveListAnimManager = new ImmersiveListAnimManager();
      manager.getItemHashcode(0);

      let data: NotificationEntryArray = new NotificationEntryArray();
      manager.setImmersiveListData(data);
      manager.getItemHashcode(0);
      expect(manager).not().assertNull();
    });

    it('test_getRootAnimStyle', Level.LEVEL0, (): void => {
      let manager: ImmersiveListAnimManager = new ImmersiveListAnimManager();
      manager.getRootAnimStyle();
      expect(manager).not().assertNull();
    });

    it('test_setRootStyleValue', Level.LEVEL0, (): void => {
      let manager: ImmersiveListAnimManager = new ImmersiveListAnimManager();
      manager.setRootStyleValue(AnimStyleType.ALPHA, 1);
      expect(manager).not().assertNull();
    });

    it('test_getRootAnimState', Level.LEVEL0, (): void => {
      let manager: ImmersiveListAnimManager = new ImmersiveListAnimManager();
      manager.getRootAnimState();
      expect(manager).not().assertNull();
    });

    it('test_getChildAnimStyle', Level.LEVEL0, (): void => {
      let manager: ImmersiveListAnimManager = new ImmersiveListAnimManager();
      manager.getChildAnimStyle('test');
      expect(manager).not().assertNull();
    });

    it('test_setChildStyleValue', Level.LEVEL0, (): void => {
      let manager: ImmersiveListAnimManager = new ImmersiveListAnimManager();
      manager.setChildStyleValue('test', AnimStyleType.ALPHA, 1);
      expect(manager).not().assertNull();
    });

    it('test_getChildAnimState', Level.LEVEL0, (): void => {
      let manager: ImmersiveListAnimManager = new ImmersiveListAnimManager();
      manager.getChildAnimState('test');
      expect(manager).not().assertNull();
    });

    it('test_removeChildAnimState', Level.LEVEL0, (): void => {
      let manager: ImmersiveListAnimManager = new ImmersiveListAnimManager();
      manager.removeChildAnimState('test');
      expect(manager).not().assertNull();
    });

    it('test_getRootViewPosition', Level.LEVEL0, (): void => {
      let manager: ImmersiveListAnimManager = new ImmersiveListAnimManager();
      manager.getRootViewPosition();
      expect(manager).not().assertNull();
    });

    it('test_setChildViewArea', Level.LEVEL0, (): void => {
      let manager: ImmersiveListAnimManager = new ImmersiveListAnimManager();
      manager.setChildViewArea('test');
      expect(manager).not().assertNull();
    });

    it('test_getChildViewPosition', Level.LEVEL0, (): void => {
      let manager: ImmersiveListAnimManager = new ImmersiveListAnimManager();
      manager.getChildViewPosition('test');
      expect(manager).not().assertNull();
    });

    it('test_setRootAnimating', Level.LEVEL0, (): void => {
      let manager: ImmersiveListAnimManager = new ImmersiveListAnimManager();
      manager.setRootAnimating(true);
      expect(manager).not().assertNull();
    });

    it('test_setChildAnimating', Level.LEVEL0, (): void => {
      let manager: ImmersiveListAnimManager = new ImmersiveListAnimManager();
      manager.setChildAnimating(true, ImmersiveAnimScene.SCENE_CAPSULE_TO_LIST_FIX);
      manager.setChildAnimating(true, ImmersiveAnimScene.SCENE_CAPSULE_TO_LIST_FIX, 'hash1');
      expect(manager).not().assertNull();
    });

    it('test_transformItemPosition', Level.LEVEL0, (): void => {
      let manager: ImmersiveListAnimManager = new ImmersiveListAnimManager();
      manager.transformItemPosition('hash1');
      manager.getItemScaleCenterY('hash1');
      expect(manager).not().assertNull();
    });

    it('test_updateListAnimParas', Level.LEVEL0, (): void => {
      let manager: ImmersiveListAnimManager = new ImmersiveListAnimManager();
      let data: NotificationEntryArray = new NotificationEntryArray();
      let entry1 = new NotificationEntry;
      entry1.creatorBundleName = 'bundlename';
      entry1.groupName = 'groupName';
      data.push(entry1);
      manager.setImmersiveListData(data);
      let lsitparam: ListAnimParas = {
        offset: 0,
        sizeChangeItem: 'sizechange',
        oldSize: 10,
        newSize: 20,
      };
      manager.setRootViewArea({width: 10,height: 10, position: {x: 1, y : 1}, globalPosition: {x: 100, y : 100}});
      manager.updateListAnimParas();
      manager.updateListAnimParas(lsitparam);
      expect(manager).not().assertNull();
    });

    it('test_checkItemAnimParas', Level.LEVEL0, (): void => {
      let manager: ImmersiveListAnimManager = new ImmersiveListAnimManager();
      let preParam: ItemAnimParas = {
        listTop: 30,
        listHeight: 10,
        itemSpace: 20,
        itemTop: 30,
        itemHeight: 10,
      };
      let ntfparams: NotificationAnimationParas = new NotificationAnimationParas(1, 1, 1, 1, 1);
      let itemParam: ItemAnimParas = {
        listTop: 10,
        listHeight: 10,
        itemSpace: 10,
        itemTop: 10,
        itemHeight: 10,
        preItemParas: preParam,
        itemAnim: ntfparams,
      };
      (manager as object)['checkItemAnimParas'](itemParam);
      itemParam.itemTop = 30;
      itemParam.listTop = 100;
      (manager as object)['checkItemAnimParas'](itemParam);
      expect(manager).not().assertNull();
    });

    it('test_checkHalfShowItemAnimParas', Level.LEVEL0, (): void => {
      let manager: ImmersiveListAnimManager = new ImmersiveListAnimManager();
      let itemParam: ItemAnimParas = {
        listTop: 10,
        listHeight: 10,
        itemSpace: 10,
        itemTop: 5,
        itemHeight: 10,
      };
      (manager as object)['checkHalfShowItemAnimParas'](itemParam);
      itemParam.itemTop = 10;
      (manager as object)['checkHalfShowItemAnimParas'](itemParam);
      itemParam.itemTop = 100;
      itemParam.itemHeight = 800;
      (manager as object)['checkHalfShowItemAnimParas'](itemParam);
      expect(manager).not().assertNull();
    });

    it('test_getClipHeightByScale', Level.LEVEL0, (): void => {
      let manager: ImmersiveListAnimManager = new ImmersiveListAnimManager();
      (manager as object)['getClipHeightByScale'](100, 10 , 50);
      expect(manager).not().assertNull();
    });

    it('test_updateItemAnimParas', Level.LEVEL0, (): void => {
      let animParam: ItemAnimParas = {
        listTop: 30,
        listHeight: 10,
        itemSpace: 20,
        itemTop: 30,
        itemHeight: 10,
      };
      let ntfparams: NotificationAnimationParas = new NotificationAnimationParas(1, 1, 1, 1, 1);
      let manager: ImmersiveListAnimManager = new ImmersiveListAnimManager();
      (manager as object)['updateItemAnimParas'](animParam, ntfparams);
      animParam.alpha = 1;
      (manager as object)['updateItemAnimParas'](animParam, ntfparams);
      animParam.scale = 2;
      (manager as object)['updateItemAnimParas'](animParam, ntfparams);
      expect(manager).not().assertNull();
    });

    it('test_startListAlignAnim', Level.LEVEL0, (): void => {
      let manager: ImmersiveListAnimManager = new ImmersiveListAnimManager();
      manager.startListAlignAnim(true, () => {});
      manager.onListHeightChange();
      expect(manager).not().assertNull();
    });

    it('test_getStartItemTop', Level.LEVEL0, (): void => {
      let manager: ImmersiveListAnimManager = new ImmersiveListAnimManager();
      (manager as object)['getStartItemTop']();
      expect(manager).not().assertNull();
    });

    it('test_getAnimCure', Level.LEVEL0, (): void => {
      let manager: ImmersiveListAnimManager = new ImmersiveListAnimManager();
      (manager as object)['getAnimCure'](ImmersiveAnimScene.SCENE_CAPSULE_TO_LIST_TOUCH);
      expect(manager).not().assertNull();
    });

    it('test_updateListAnimParas2', Level.LEVEL0, (): void => {
      let manager = new ImmersiveListAnimManager();
      manager.setChildViewArea('11');
      let staticState: NtfListStaticState = new NtfListStaticState();
      staticState.startItemIndex = 0;
      staticState.getListScroller().scrollTo({xOffset: 5, yOffset: 5})
      manager.setListStaticState(staticState);
      manager.setRootViewArea({width: 100, height: 100});
      manager.updateListAnimParas();

      manager.updateListAnimParas({
        oldSize: 10,
        newSize: 10
      });
      expect(manager).not().assertNull();
    });

    it('test_pkgItemAnimParas', Level.LEVEL0, (): void => {
      let manager = new ImmersiveListAnimManager();
      manager.setChildViewArea('11');
      let entry: NotificationEntry = new NotificationEntry();
      manager.setImmersiveListData([entry]);
      (manager as object)['pkgItemAnimParas'](0, { itemTop: 1, itemHeight: 2, listTop: 3, listHeight: 4 },
        { itemTop: 1, itemHeight: 2, listTop: 3, listHeight: 4 });
      expect(manager).not().assertNull();
    });
  });
}

interface ItemAnimParas { // 条目跟手滑动参数
  listTop: number;
  listHeight: number;
  itemSpace: number;
  itemAnim?: NotificationAnimationParas;
  preItemParas?: ItemAnimParas;
  itemTop: number;
  itemHeight: number;

  // 动效生效参数
  alpha?: number;
  scale?: number;
  scaleCenterY?: number;
  tranY?: number;
  clipHeight?: number;
  clipOffsetY?: number;
  zIndex?: number;
  isEnable?: boolean;
}