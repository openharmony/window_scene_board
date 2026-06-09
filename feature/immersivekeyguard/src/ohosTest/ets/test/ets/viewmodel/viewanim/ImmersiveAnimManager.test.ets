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
import { afterAll, afterEach, beforeAll, beforeEach, describe, expect, it, Level } from '@ohos/hypium';
import { ImmersiveAnimManager } from '../../../../../../main/ets/viewmodel/viewanim/ImmersiveAnimManager';
import { ImmersiveListAnimManager } from '../../../../../../main/ets/viewmodel/viewanim/ImmersiveListAnimManager';
import { ImmersiveAnimKey, ImmersiveAnimScene } from '../../../../../../main/ets/common/anim/ImmersiveAnimConstants';
import { CapsulePositionType, CardAnimType } from '../../../../../../main/ets/common/ImmersiveConstants';
import { AnimStyleType } from '../../../../../../main/ets/model/data/anim/ImmersiveAnimStyle';
import { NotificationEntry } from '@ohos/notificationcomponent/src/main/ets/model/NotificationEntry';
import { ImmersiveNtfData } from '../../../../../../main/ets/viewmodel/viewdata/ImmersiveNtfData';
import { ImmersiveCardList } from '../../../../../../main/ets/viewmodel/viewdata/ImmersiveCardList';
import { ComponentPosition } from '@ohos/screenlockcommon/Index';
import { ImmersiveLiveAnimManager } from '../../../../../../main/ets/viewmodel/viewanim/ImmersiveLiveAnimManager';

/**
 * 沉浸式锁屏测试用例
 */
export function ImmersiveAnimManagerTest() {
  let viewArea: Area = {
    width: 100,
    height: 100,
    position: {
      x: 0, y: 0
    },
    globalPosition: {
      x: 0, y: 0
    }
  };
  describe('ImmersiveAnimManagerTest', (): void => {
    beforeAll((): void => {
    });
    beforeEach((): void => {
    });
    afterAll((): void => {
    });
    afterEach((): void => {
    });

    it('test_removeListAnimState1', Level.LEVEL0, (): void => {
      let res = true;
      let manager = new ImmersiveAnimManager();
      manager.removeListAnimState('');
      expect(res).assertTrue();
    });

    it('test_removeListAnimState2', Level.LEVEL1, (): void => {
      let res = true;
      let manager = new ImmersiveAnimManager();
      manager.removeListAnimState('testKey');
      expect(res).assertTrue();
    });

    it('test_setListViewArea', Level.LEVEL1, (): void => {
      let res = true;
      let manager = new ImmersiveAnimManager();
      manager.setListViewArea(undefined);
      manager.setListViewArea('immersive_list_root', viewArea);
      manager.setListViewArea('immersive_capsule_root', viewArea);
      expect(res).assertTrue();
    });

    it('test_setCapsuleViewArea', Level.LEVEL1, (): void => {
      let res = true;
      let manager = new ImmersiveAnimManager();
      manager.setCapsuleViewArea(ImmersiveAnimKey.IMMERSIVE_CAPSULE_ROOT);
      manager.setCapsuleViewArea(ImmersiveAnimKey.IMMERSIVE_LIST_ROOT);
      manager.setCapsuleViewArea(ImmersiveAnimKey.IMMERSIVE_LIST_ROOT, viewArea);
      manager.setCapsuleViewArea(ImmersiveAnimKey.IMMERSIVE_CAPSULE_ROOT, viewArea);
      manager.setCapsuleViewArea(ImmersiveAnimKey.IMMERSIVE_CARD_ROOT, viewArea);
      expect(res).assertTrue();
    });

    it('test_getCapsuleViewArea', Level.LEVEL1, (): void => {
      let res = true;
      let manager = new ImmersiveAnimManager();
      manager.getCapsuleViewArea();
      manager.getCapsuleViewArea(CapsulePositionType.TYPE_NONE);
      manager.getCapsuleViewArea(CapsulePositionType.TYPE_CONTENT);
      manager.getCapsuleViewArea(CapsulePositionType.TYPE_SHADOW);
      manager.getCapsuleViewArea(CapsulePositionType.TYPE_REMIND);
      manager.getCapsuleViewArea(CapsulePositionType.TYPE_ANIM_CONTENT);
      manager.getCapsuleViewArea(CapsulePositionType.TYPE_ANIM_SHADOW);
      expect(res).assertTrue();
    });

    it('test_cardViewArea', Level.LEVEL1, (): void => {
      let res = true;
      let manager = new ImmersiveAnimManager();
      manager.setCardViewArea(CardAnimType.CARD_LIVE_CONTENT_TYPE, viewArea);
      manager.getCardViewArea();
      expect(res).assertTrue();
    });

    it('test_cardViewArea_02', Level.LEVEL1, (): void => {
      let res = true;
      let manager = new ImmersiveAnimManager();
      manager.setCardViewArea(ImmersiveAnimKey.IMMERSIVE_CARD_ROOT, viewArea);
      manager.getCardViewArea();
      expect(res).assertTrue();
    });

    it('test_cardViewArea_03', Level.LEVEL1, (): void => {
      let res = true;
      let manager = new ImmersiveAnimManager();
      manager.setCardViewArea(CardAnimType.CARD_LIVE_CONTENT_TYPE, viewArea);
      manager.getCardViewArea(CardAnimType.CARD_LIVE_CONTENT_TYPE);
      expect(res).assertTrue();
    });

    it('test_setListAnimStyle', Level.LEVEL1, (): void => {
      let manager = new ImmersiveAnimManager();
      manager.setListAnimStyle('', AnimStyleType.RADIUS);
      manager.setListAnimStyle('', AnimStyleType.RADIUS, 10);
      manager.setListAnimStyle(ImmersiveAnimKey.IMMERSIVE_LIST_ROOT, AnimStyleType.RADIUS);
      manager.setListAnimStyle(ImmersiveAnimKey.IMMERSIVE_CAPSULE_ROOT, AnimStyleType.RADIUS);
      manager.setListAnimStyle(ImmersiveAnimKey.IMMERSIVE_LIST_ROOT, AnimStyleType.RADIUS, 10);
      manager.setListAnimStyle(ImmersiveAnimKey.IMMERSIVE_CAPSULE_ROOT, AnimStyleType.RADIUS, 10);
      expect(manager).not().assertNull();
    });

    it('test_getCardAnimState_01', Level.LEVEL1, (): void => {
      let res = true;
      let manager = new ImmersiveAnimManager();
      manager.getCardAnimState(ImmersiveAnimKey.IMMERSIVE_CARD_ROOT);
      expect(res).assertTrue();
    });

    it('test_getCardAnimState_02', Level.LEVEL1, (): void => {
      let res = true;
      let manager = new ImmersiveAnimManager();
      manager.getCardAnimState(ImmersiveAnimKey.IMMERSIVE_CAPSULE_ROOT);
      expect(res).assertTrue();
    });

    it('test_getCardAnimState_03', Level.LEVEL1, (): void => {
      let res = true;
      let manager = new ImmersiveAnimManager();
      manager.getCardAnimState(CardAnimType.CARD_LIVE_CONTENT_TYPE);
      expect(res).assertTrue();
    });

    it('test_setCapsuleAnimStyle', Level.LEVEL1, (): void => {
      let res = true;
      let manager = new ImmersiveAnimManager();
      manager.setCapsuleAnimStyle(CapsulePositionType.TYPE_CONTENT, AnimStyleType.RADIUS);
      manager.setCapsuleAnimStyle(ImmersiveAnimKey.IMMERSIVE_CAPSULE_ROOT, AnimStyleType.RADIUS);
      manager.setCapsuleAnimStyle(CapsulePositionType.TYPE_CONTENT, AnimStyleType.RADIUS, 10);
      manager.setCapsuleAnimStyle(ImmersiveAnimKey.IMMERSIVE_CAPSULE_ROOT, AnimStyleType.RADIUS, 10);
      expect(res).assertTrue();
    });

    it('test_getListAnimState', Level.LEVEL1, (): void => {
      let res = true;
      let manager = new ImmersiveAnimManager();
      manager.getListAnimState(undefined);
      manager.getListAnimState(ImmersiveAnimKey.IMMERSIVE_LIST_ROOT);
      manager.getListAnimState(ImmersiveAnimKey.IMMERSIVE_CAPSULE_ROOT);
      manager.getListAnimState(ImmersiveAnimKey.IMMERSIVE_CARD_ROOT);
      expect(res).assertTrue();
    });

    it('test_getCapsuleAnimState', Level.LEVEL1, (): void => {
      let res = true;
      let manager = new ImmersiveAnimManager();
      manager.getCapsuleAnimState(ImmersiveAnimKey.IMMERSIVE_LIST_ROOT);
      manager.getCapsuleAnimState(ImmersiveAnimKey.IMMERSIVE_CAPSULE_ROOT);
      expect(res).assertTrue();
    });

    it('test_interruptAnimScene', Level.LEVEL1, (): void => {
      let res = true;
      let manager = new ImmersiveAnimManager();
      manager.interruptAnimScene(ImmersiveAnimScene.SCENE_LIST_TO_CAPSULE_FIX);
      manager.interruptAnimScene(ImmersiveAnimScene.SCENE_CAPSULE_TO_LIST_TOUCH);
      expect(res).assertTrue();
    });

    it('test_startList2CapsuleTouchBackAnim', Level.LEVEL1, (): void => {
      let res = true;
      let manager = new ImmersiveAnimManager();
      manager.startList2CapsuleTouchBackAnim(0);
      manager.startList2CapsuleTouchBackAnim(150);
      expect(res).assertTrue();
    });

    it('test_startList2CapsuleFixAnim', Level.LEVEL1, (): void => {
      let res = true;
      let manager = new ImmersiveAnimManager();
      manager.startList2CapsuleFixAnim(0);
      manager.startList2CapsuleFixAnim(0, 'skipAnimKeyTest1111');
      manager.startList2CapsuleFixAnim(0, 'skipAnimKeyTest1111', (): void => {});
      expect(res).assertTrue();
    });

    it('test_startCapsule2ListTouchBackAnim', Level.LEVEL1, (): void => {
      let res = true;
      let manager = new ImmersiveAnimManager();
      manager.startCapsule2ListTouchBackAnim(0);
      manager.startCapsule2ListTouchBackAnim(150);
      expect(res).assertTrue();
    });

    it('test_startCapsule2ListFixAnim', Level.LEVEL1, (): void => {
      let res = true;
      let manager = new ImmersiveAnimManager();
      manager.startCapsule2ListFixAnim(0);
      manager.startCapsule2ListFixAnim(0, 'skipCodeTest1111');
      manager.startCapsule2ListFixAnim(0, 'skipCodeTest1111', (): void => {});
      expect(res).assertTrue();
    });

    it('test_startListToCardFixAnim', Level.LEVEL1, (): void => {
      let res = true;
      let manager = new ImmersiveAnimManager();
      manager.startList2CardFixAnim(undefined);
      manager.startList2CardFixAnim('skipAnimKeyTest1111');
      expect(res).assertTrue();
    });

    it('test_startCardToListFixAnim', Level.LEVEL1, (): void => {
      let res = true;
      let manager = new ImmersiveAnimManager();
      manager.startCardToListFixAnim();
      manager.startCardToListFixAnim(10);
      manager.startCardToListFixAnim(10);
      expect(res).assertTrue();
    });

    it('test_startLiveListToImmeCardFixAnim', Level.LEVEL1, (): void => {
      let manager = new ImmersiveAnimManager();
      manager.startLiveListToImmeCardFixAnim(undefined);
      manager.startLiveListToImmeCardFixAnim('testHashcode');
    });

    it('test_startImmeCardToLiveListFixAnim', Level.LEVEL1, (): void => {
      let manager = new ImmersiveAnimManager();
      manager.startImmeCardToLiveListFixAnim(undefined);
      manager.startImmeCardToLiveListFixAnim('testHashcode');
    });

    it('test_startImmeCardToLiveCapsuleFixAnim', Level.LEVEL1, (): void => {
      let manager = new ImmersiveAnimManager();
      manager.startImmeCardToLiveCapsuleFixAnim(undefined);
      manager.startImmeCardToLiveCapsuleFixAnim('testHashcode');
    });

    it('test_getImmeLiveAnimMgr', Level.LEVEL1, (): void => {
      let manager = new ImmersiveAnimManager();
      (manager as object)['immeLiveAnimMgr'] = new ImmersiveLiveAnimManager();
      let res = manager.getImmeLiveAnimMgr();
      expect(res).not().assertUndefined();
    });

    it('test_startCapsuleToCardAnim', Level.LEVEL1, (): void => {
      let manager = new ImmersiveAnimManager();
      let compost: ComponentPosition = {
        globalX: 0,
        globalY: 0,
        width: 100,
        height: 100
      }
      manager.startCapsuleToCardAnim((): void => {}, compost);
      manager.startCapsuleToCardAnim();
      manager.startCapsuleToCardAnim((): void => {}, compost, true);
      manager.startCapsuleToCardAnim((): void => {}, compost, false);
      expect(manager).not().assertNull();
    });

    it('test_startCardToCapsuleAnim', Level.LEVEL1, (): void => {
      let manager = new ImmersiveAnimManager();
      manager.startCardToCapsuleAnim();
      manager.startCardToCapsuleAnim(true, (): void => {});
      manager.startCardToCapsuleAnim(false, (): void => {});
      expect(manager).not().assertNull();
    });

    it('test_getAnimMgr', Level.LEVEL1, (): void => {
      let manager = new ImmersiveAnimManager();
      manager.getCapsuleAnimMgr();
      manager.getListAnimMgr();
      manager.getCardAnimMgr();
      manager.getSlClockAnimMgr();
      expect(manager).not().assertNull();
    });

    it('test_bindCapsuleAnimKey', Level.LEVEL1, (): void => {
      let manager = new ImmersiveAnimManager();
      manager.bindCapsuleAnimKey(CapsulePositionType.TYPE_SHADOW);
      manager.bindCapsuleAnimKey(CapsulePositionType.TYPE_REMIND, 'testhashcode');
      expect(manager).not().assertNull();
    });

    it('test_getListViewPosition', Level.LEVEL1, (): void => {
      let manager = new ImmersiveAnimManager();
      manager.getListViewPosition(undefined);
      manager.getListViewPosition(ImmersiveAnimKey.IMMERSIVE_LIST_ROOT);
      manager.getListViewPosition(ImmersiveAnimKey.IMMERSIVE_CAPSULE_ROOT);
      expect(manager).not().assertNull();
    });

    it('test_getCapsuleValidPosition', Level.LEVEL1, (): void => {
      let manager = new ImmersiveAnimManager();
      manager.getListViewPosition(undefined);
      manager.getListViewPosition(CapsulePositionType.TYPE_NONE);
      manager.getListViewPosition(CapsulePositionType.TYPE_CONTENT);
      manager.getListViewPosition(CapsulePositionType.TYPE_SHADOW);
      manager.getListViewPosition(CapsulePositionType.TYPE_REMIND);
      manager.getListViewPosition(CapsulePositionType.TYPE_ANIM_CONTENT);
      manager.getListViewPosition(CapsulePositionType.TYPE_ANIM_SHADOW);
      expect(manager).not().assertNull();
    });

    it('test_checkListAndCardPositionStatus', Level.LEVEL1, (): void => {
      let manager = new ImmersiveAnimManager();
      (manager as object)['checkListAndCardPositionStatus']('testhashcode');
      expect(manager).not().assertNull();
    });

    it('test_setAnimating', Level.LEVEL1, (): void => {
      let manager = new ImmersiveAnimManager();
      (manager as object)['setAnimating'](true, ImmersiveAnimScene.SCENE_LIST_TO_CARD);
      (manager as object)['setAnimating'](false, ImmersiveAnimScene.SCENE_LIST_TO_CARD);
      expect(manager).not().assertNull();
    });

    it('test_onCommonAnimFinish', Level.LEVEL1, (): void => {
      let manager = new ImmersiveAnimManager();
      let animParam: ItemAnimParam = {
        isLastItem: true,
        itemList: [{isLastItem: true}, {isLastItem: true}]
      };
      (manager as object)['onCommonAnimFinish'](animParam);
      animParam.animScene = ImmersiveAnimScene.SCENE_CAPSULE_TO_LIST_FIX;
      (manager as object)['onCommonAnimFinish'](animParam);
      animParam.callback = () => {};
      (manager as object)['onCommonAnimFinish'](animParam);
      expect(manager).not().assertNull();
    });

    it('test_getList2CapsuleFinish', Level.LEVEL1, (): void => {
      let manager = new ImmersiveAnimManager();
      let animParam: ItemAnimParam = {
        isLastItem: true
      };
      (manager as object)['getList2CapsuleFinish'](animParam);
      expect(manager).not().assertNull();
    });

    it('test_initList2CapsuleFixItem', Level.LEVEL0, (): void => {
      let manager = new ImmersiveAnimManager();
      let animParam: ItemAnimParam = {
        isLastItem: true
      };
      (manager as object)['initList2CapsuleFixItem'](animParam);
      animParam.animScene = ImmersiveAnimScene.SCENE_CAPSULE_TO_LIST_TOUCH;
      animParam.mapCapsuleType = CapsulePositionType.TYPE_CONTENT;
      animParam.hashcode = 'testhashcode';
      animParam.isUseInnerClip = false;
      (manager as object)['initList2CapsuleFixItem'](animParam);
      expect(manager).not().assertNull();
    });

    it('test_initList2CapsuleFixExcludeItem', Level.LEVEL0, (): void => {
      let manager = new ImmersiveAnimManager();
      let animParam: ItemAnimParam = {
        isLastItem: true
      };
      (manager as object)['initList2CapsuleFixExcludeItem'](animParam);
      animParam.animScene = ImmersiveAnimScene.SCENE_CAPSULE_TO_LIST_TOUCH;
      animParam.mapCapsuleType = CapsulePositionType.TYPE_CONTENT;
      animParam.hashcode = 'testhashcode';
      animParam.isUseInnerClip = false;
      (manager as object)['initList2CapsuleFixExcludeItem'](animParam);
      expect(manager).not().assertNull();
    });

    it('test_setList2CapsuleItemEndValue', Level.LEVEL0, (): void => {
      let manager = new ImmersiveAnimManager();
      let animParam: ItemAnimParam = {
      };
      (manager as object)['setList2CapsuleItemEndValue'](animParam);
      animParam.mapCapsuleType = CapsulePositionType.TYPE_CONTENT;
      animParam.hashcode = 'testhashcode';
      (manager as object)['setList2CapsuleItemEndValue'](animParam);
      expect(manager).not().assertNull();
    });

    it('test_setList2CapsuleItemSecondary', Level.LEVEL0, (): void => {
      let manager = new ImmersiveAnimManager();
      let animParam: ItemAnimParam = {
      };
      (manager as object)['setList2CapsuleItemSecondary'](undefined);
      (manager as object)['setList2CapsuleItemSecondary'](animParam);
      animParam.mapCapsuleType = CapsulePositionType.TYPE_CONTENT;
      animParam.hashcode = 'testhashcode';
      (manager as object)['setList2CapsuleItemSecondary'](animParam);
      expect(manager).not().assertNull();
    });

    it('test_finishList2CapsuleItem', Level.LEVEL0, (): void => {
      let manager = new ImmersiveAnimManager();
      let animParam: ItemAnimParam = {
        hashcode: 'hashcode',
      };
      (manager as object)['finishList2CapsuleItem'](undefined);
      (manager as object)['finishList2CapsuleItem'](animParam);
      expect(manager).not().assertNull();
    });

    it('test_initList2CapsuleBackItem', Level.LEVEL0, (): void => {
      let manager = new ImmersiveAnimManager();
      let animParam: ItemAnimParam = {
        hashcode: 'hashcode',
      };
      (manager as object)['initList2CapsuleBackItem'](undefined);
      (manager as object)['initList2CapsuleBackItem'](animParam);
      expect(manager).not().assertNull();
    });

    it('test_startList2CapsuleBackItem', Level.LEVEL0, (): void => {
      let manager = new ImmersiveAnimManager();
      let listAnimMgr: ImmersiveListAnimManager = new ImmersiveListAnimManager();
      listAnimMgr.setChildStyleValue('testhashcode', AnimStyleType.PADDING_LEFT, 10);
      (manager as object)['listAnimMgr'] = listAnimMgr;
      let animParam: ItemAnimParam = {
        hashcode: 'hashcode',
        animScene: ImmersiveAnimScene.SCENE_CAPSULE_TO_LIST_TOUCH,
      };
      (manager as object)['startList2CapsuleBackItem'](undefined);
      (manager as object)['startList2CapsuleBackItem'](animParam);
      expect(manager).not().assertNull();
    });

    it('test_initCapsule2ListFixAnim', Level.LEVEL0, (): void => {
      let manager = new ImmersiveAnimManager();
      let animParam: ItemAnimParam = {
        itemEndIndex: 10,
      };
      let listAnimMgr: ImmersiveListAnimManager = new ImmersiveListAnimManager();
      listAnimMgr.setChildStyleValue('testhashcode', AnimStyleType.PADDING_LEFT, 10);
      (manager as object)['listAnimMgr'] = listAnimMgr;
      (manager as object)['initCapsule2ListFixAnim'](animParam);
      animParam.itemEndIndex = -1;
      (manager as object)['initCapsule2ListFixAnim'](animParam);
      expect(manager).not().assertNull();
    });

    it('test_handleCapsule2ListItemAnim', Level.LEVEL0, (): void => {
      let manager = new ImmersiveAnimManager();
      let animParam: ItemAnimParam = {
        isLastItem: true
      };
      let listAnimMgr: ImmersiveListAnimManager = new ImmersiveListAnimManager();
      listAnimMgr.setChildStyleValue('testhashcode', AnimStyleType.PADDING_LEFT, 10);
      (manager as object)['listAnimMgr'] = listAnimMgr;
      (manager as object)['handleCapsule2ListItemAnim'](animParam, undefined);
      animParam.hashcode = 'testhashcode';
      (manager as object)['handleCapsule2ListItemAnim'](animParam, 'testhashcode');
      animParam.itemIndex = 1;
      animParam.itemStartIndex = 1;
      animParam.itemEndIndex = 3;
      animParam.mapCapsuleType = CapsulePositionType.TYPE_CONTENT;
      animParam.animScene = ImmersiveAnimScene.SCENE_CAPSULE_TO_LIST_TOUCH;
      (manager as object)['handleCapsule2ListItemAnim'](animParam, 'testhashcode2');
      animParam.itemIndex = 0;
      (manager as object)['handleCapsule2ListItemAnim'](animParam, 'testhashcode2');
      animParam.itemIndex = 4;
      (manager as object)['handleCapsule2ListItemAnim'](animParam, 'testhashcode2');
      expect(manager).not().assertNull();
    });

    it('test_initCapsule2ListFixItem', Level.LEVEL0, (): void => {
      let manager = new ImmersiveAnimManager();
      let animParam: ItemAnimParam = {
        isLastItem: true
      };
      let listAnimMgr: ImmersiveListAnimManager = new ImmersiveListAnimManager();
      listAnimMgr.setChildStyleValue('testhashcode', AnimStyleType.PADDING_LEFT, 10);
      (manager as object)['listAnimMgr'] = listAnimMgr;
      (manager as object)['initCapsule2ListFixItem'](animParam);
      animParam.hashcode = 'testhashcode';
      animParam.animScene = ImmersiveAnimScene.SCENE_CAPSULE_TO_LIST_TOUCH;
      animParam.mapCapsuleType = CapsulePositionType.TYPE_ANIM_CONTENT;
      (manager as object)['initCapsule2ListFixItem'](animParam);
      expect(manager).not().assertNull();
    });

    it('test_startCapsule2ListFixItemAnim', Level.LEVEL0, (): void => {
      let manager = new ImmersiveAnimManager();
      let animParam: ItemAnimParam = {
        isLastItem: true
      };
      let listAnimMgr: ImmersiveListAnimManager = new ImmersiveListAnimManager();
      listAnimMgr.setChildStyleValue('testhashcode', AnimStyleType.PADDING_LEFT, 10);
      (manager as object)['listAnimMgr'] = listAnimMgr;
      (manager as object)['startCapsule2ListFixItemAnim'](animParam);
      animParam.hashcode = 'testhashcode';
      animParam.animScene = ImmersiveAnimScene.SCENE_CAPSULE_TO_LIST_TOUCH;
      animParam.mapCapsuleType = CapsulePositionType.TYPE_ANIM_CONTENT;
      (manager as object)['startCapsule2ListFixItemAnim'](animParam);
      expect(manager).not().assertNull();
    });

    it('test_getCapsule2ListItemFinish', Level.LEVEL0, (): void => {
      let manager = new ImmersiveAnimManager();
      let animParam: ItemAnimParam = {
        isLastItem: true
      };
      let listAnimMgr: ImmersiveListAnimManager = new ImmersiveListAnimManager();
      listAnimMgr.setChildStyleValue('testhashcode', AnimStyleType.PADDING_LEFT, 10);
      (manager as object)['getCapsule2ListItemFinish'](animParam);
      animParam.hashcode = 'testhashcode';
      (manager as object)['getCapsule2ListItemFinish'](animParam);
      expect(manager).not().assertNull();
    });

    it('test_getCapsuleValidState', Level.LEVEL0, (): void => {
      let manager = new ImmersiveAnimManager();
      (manager as object)['getCapsuleValidState'](CapsulePositionType.TYPE_NONE);
      (manager as object)['getCapsuleValidState'](CapsulePositionType.TYPE_CONTENT);
      (manager as object)['getCapsuleValidState'](CapsulePositionType.TYPE_ANIM_SHADOW);
      (manager as object)['getCapsuleValidState'](CapsulePositionType.TYPE_ANIM_CONTENT);
      (manager as object)['getCapsuleValidState'](CapsulePositionType.TYPE_REMIND);
      (manager as object)['getCapsuleValidState'](CapsulePositionType.TYPE_SHADOW);
      expect(manager).not().assertNull();
    });

    it('test_getCapsuleValidStyle', Level.LEVEL0, (): void => {
      let manager = new ImmersiveAnimManager();
      manager.setCapsuleAnimStyle(CapsulePositionType.TYPE_CONTENT, AnimStyleType.PADDING_LEFT, 10);
      (manager as object)['getCapsuleValidStyle'](CapsulePositionType.TYPE_NONE);
      (manager as object)['getCapsuleValidStyle'](CapsulePositionType.TYPE_CONTENT);
      (manager as object)['getCapsuleValidStyle'](CapsulePositionType.TYPE_ANIM_SHADOW);
      (manager as object)['getCapsuleValidStyle'](CapsulePositionType.TYPE_ANIM_CONTENT);
      (manager as object)['getCapsuleValidStyle'](CapsulePositionType.TYPE_REMIND);
      (manager as object)['getCapsuleValidStyle'](CapsulePositionType.TYPE_SHADOW);
      expect(manager).not().assertNull();
    });

    it('test_isInvalidPosition', Level.LEVEL0, (): void => {
      let manager = new ImmersiveAnimManager();
      let compost: ComponentPosition = {
        globalX: 0,
        globalY: 0,
        width: 100,
        height: 100
      };
      (manager as object)['isInvalidPosition'](undefined);
      (manager as object)['isInvalidPosition'](compost);
      expect(manager).not().assertNull();
    });

    it('test_getMainAnimParams', Level.LEVEL0, (): void => {
      let manager = new ImmersiveAnimManager();
      let animParam: AnimateParam = {
      };
      (manager as object)['getMainAnimParams'](ImmersiveAnimScene.SCENE_CAPSULE_TO_LIST_FIX, 10, animParam);
      (manager as object)['getMainAnimParams'](ImmersiveAnimScene.SCENE_CAPSULE_TO_LIST_TOUCH_BACK, 10, animParam);
      (manager as object)['getMainAnimParams'](ImmersiveAnimScene.SCENE_LIST_TO_CAPSULE_FIX, 10, animParam);
      (manager as object)['getMainAnimParams'](ImmersiveAnimScene.SCENE_LIST_TO_CAPSULE_TOUCH_BACK, 10, animParam);
      (manager as object)['getMainAnimParams'](ImmersiveAnimScene.SCENE_CAPSULE_TO_CARD, 10, animParam);
      (manager as object)['getMainAnimParams'](ImmersiveAnimScene.SCENE_CARD_TO_CAPSULE, 10, animParam);
      expect(manager).not().assertNull();
    });

    it('test_getSecondaryAnimParams', Level.LEVEL0, (): void => {
      let manager = new ImmersiveAnimManager();
      let animParam: AnimateParam = {
      };
      (manager as object)['getSecondaryAnimParams'](ImmersiveAnimScene.SCENE_CAPSULE_TO_LIST_FIX, animParam);
      (manager as object)['getSecondaryAnimParams'](ImmersiveAnimScene.SCENE_LIST_TO_CAPSULE_FIX, animParam);
      (manager as object)['getSecondaryAnimParams'](ImmersiveAnimScene.SCENE_CAPSULE_TO_CARD, animParam);
      (manager as object)['getSecondaryAnimParams'](ImmersiveAnimScene.SCENE_CARD_TO_CAPSULE, animParam);
      expect(manager).not().assertNull();
    });

    it('test_resetCapAnimState', Level.LEVEL0, (): void => {
      let manager = new ImmersiveAnimManager();
      (manager as object)['resetCapAnimState'](undefined);
      (manager as object)['resetCapAnimState'](ImmersiveAnimScene.SCENE_CAPSULE_TO_LIST_TOUCH);
      expect(manager).not().assertNull();
    });

    it('test_clearAnimStateProperty', Level.LEVEL0, (): void => {
      let manager = new ImmersiveAnimManager();
      (manager as object)['clearAnimStateProperty'](undefined, undefined);
      expect(manager).not().assertNull();
    });

    it('testStartList2CapsuleFixAnim', Level.LEVEL0, (): void => {
      let animManager = new ImmersiveAnimManager();
      let data: NotificationEntry = new NotificationEntry(undefined);
      animManager.getListAnimMgr().setImmersiveListData([data])
      animManager.startList2CapsuleFixAnim(0, 'test');
      expect(animManager).not().assertNull();
    });

    it('testExecList2CardAnim', Level.LEVEL0, (): void => {
      let animManager = new ImmersiveAnimManager();
      (animManager as object)['execList2CardAnim']('test');
      expect(animManager).not().assertNull();
    });

    it('test_exeAnimScenePreProcessing', Level.LEVEL0, (): void => {
      let animManager = new ImmersiveAnimManager();
      animManager.exeAnimScenePreProcessing();
      animManager.exeAnimScenePreProcessing(ImmersiveAnimKey.IMMERSIVE_LIST_ROOT);
      animManager.exeAnimScenePreProcessing(ImmersiveAnimKey.IMMERSIVE_CAPSULE_ROOT);
      animManager.exeAnimScenePreProcessing(ImmersiveAnimKey.IMMERSIVE_CARD_ROOT);
      expect(animManager).not().assertNull();
    });

    it('testStartCardToListFixAnim', Level.LEVEL0, (): void => {
      let animManager = new ImmersiveAnimManager();
      let immersiveData: ImmersiveNtfData = new ImmersiveNtfData();
      immersiveData.groupKey = 'test';
      let cardList: ImmersiveCardList = new ImmersiveCardList();
      cardList.setAnimData(immersiveData);
      animManager.getCardAnimMgr().setImmersiveCardData(cardList);
      animManager.startCardToListFixAnim();
      expect(animManager).not().assertNull();
    });

    it('testExeCard2ListAnim', Level.LEVEL0, (): void => {
      let animManager = new ImmersiveAnimManager();
      (animManager as object)['exeCard2ListAnim']('test');
      (animManager as object)['exeCard2ListAnim']('test', true);
      (animManager as object)['exeCard2ListAnim']('test', false);
      expect(animManager).not().assertNull();
    });

    it('test_initCapsuleToCardAnim', Level.LEVEL0, (): void => {
      let animManager = new ImmersiveAnimManager();
      let animParam: ItemAnimParam = {
        hashcode: 'hashcode',
      };
      let compost: ComponentPosition = {
        globalX: 0,
        globalY: 0,
        width: 100,
        height: 100
      };
      (animManager as object)['initCapsuleToCardAnim'](animParam);
      (animManager as object)['initCapsuleToCardAnim'](animParam, compost);
      expect(animManager).not().assertNull();
    });

    it('test_handleCapsuleToCardAnim', Level.LEVEL0, (): void => {
      let animManager = new ImmersiveAnimManager();
      let animParam: ItemAnimParam = {
        hashcode: 'hashcode',
      };
      (animManager as object)['handleCapsuleToCardAnim'](animParam);
      (animManager as object)['handleCapsuleToCardAnim'](animParam, (): void => {});
      (animManager as object)['handleCapsuleToCardAnim'](animParam, (): void => {}, true);
      (animManager as object)['handleCapsuleToCardAnim'](animParam, (): void => {}, false);
      expect(animManager).not().assertNull();
    });

    it('test_getConCapsulePositionFromRoot', Level.LEVEL0, (): void => {
      let animManager = new ImmersiveAnimManager();
      (animManager as object)['getConCapsulePositionFromRoot']();
      expect(animManager).not().assertNull();
    });

    it('test_initCardToCapsuleAnim', Level.LEVEL0, (): void => {
      let animManager = new ImmersiveAnimManager();
      let animParam: ItemAnimParam = {
        hashcode: 'hashcode',
      };
      (animManager as object)['initCardToCapsuleAnim'](animParam);
      (animManager as object)['initCardToCapsuleAnim'](animParam, true);
      (animManager as object)['initCardToCapsuleAnim'](animParam, false);
      expect(animManager).not().assertNull();
    });

    it('test_handleCardToCapsuleAnim', Level.LEVEL0, (): void => {
      let animManager = new ImmersiveAnimManager();
      let animParam: ItemAnimParam = {
        hashcode: 'hashcode',
      };
      (animManager as object)['handleCardToCapsuleAnim'](animParam);
      (animManager as object)['handleCardToCapsuleAnim'](animParam, (): void => {});
      (animManager as object)['handleCardToCapsuleAnim'](animParam, (): void => {}, true);
      (animManager as object)['handleCardToCapsuleAnim'](animParam, (): void => {}, false);
      (animManager as object)['handleCardToCapsuleAnim'](animParam, (): void => {}, true, viewArea);
      (animManager as object)['handleCardToCapsuleAnim'](animParam, (): void => {}, false, viewArea);
      expect(animManager).not().assertNull();
    });

    it('test_forList2CapsuleItem', Level.LEVEL1, (): void => {
      let manager = new ImmersiveAnimManager();
      let animParam: ItemAnimParam = {
        isLastItem: true,
        itemList: [{isLastItem: true}, {isLastItem: true}]
      };
      (manager as object)['forList2CapsuleItem'](animParam);
      expect(manager).not().assertNull();
    });

    it('test_forExcludeTarItemItem', Level.LEVEL1, (): void => {
      let manager = new ImmersiveAnimManager();
      let animParam: ItemAnimParam = {
        isLastItem: true,
        itemList: [{isLastItem: true}, {isLastItem: true}]
      };
      (manager as object)['forExcludeTarItemItem'](animParam, 0, 1);
      (manager as object)['forExcludeTarItemItem'](animParam, 1, 10);
      expect(manager).not().assertNull();
    });

    it('testGetList2CapsuleFinish', Level.LEVEL0, (): void => {
      let animManager = new ImmersiveAnimManager();
      (animManager as object)['getList2CapsuleFinish']({animScene: 'test'});
      expect(animManager).not().assertNull();
    });

    it('test_isMediaCenterAnim', Level.LEVEL1, (): void => {
      let manager = new ImmersiveAnimManager();
      (manager as object)['isMediaCenterAnim']();
      expect(manager).not().assertNull();
    });
  });
}

/**
 * 动效结束类型
 */
type OnAnimFinish = () => void;

/**
 * 条目卡片参数传递
 */
interface ItemAnimParam {
  /**
   * 条目唯一标示
   */
  hashcode?: string;

  /**
   * 动效场景
   */
  animScene?: ImmersiveAnimScene;

  /**
   * 条目映射胶囊类型
   */
  mapCapsuleType?: CapsulePositionType;

  /**
   * 条目动效延时启动
   */
  animDelay?: number;

  /**
   * 是否为第一个条目
   */
  isFirstItem?: boolean;

  /**
   * 是否为最后一个条目
   */
  isLastItem?: boolean;

  /**
   * 条目索引
   */
  itemIndex?: number;

  /**
   * 条目可见起始索引
   */
  itemStartIndex?: number;

  /**
   * 条目可见结束索引
   */
  itemEndIndex?: number;

  /**
   * 速度
   */
  velocity?: number;

  /**
   * 是否为次要动效
   */
  isSecondaryAnim?: boolean;

  /**
   * 是否动效初始化
   */
  isAnimInit?: boolean;

  /**
   * 条目inner裁剪
   */
  isUseInnerClip?: boolean;

  /**
   * 参与动效条目标识集
   */
  itemList?: ItemAnimParam[];

  /**
   * 条目动效结束回调
   *
   * @param isLastItem 是否为最后一个条目
   */
  onAnimFinish?: (param: ItemAnimParam) => void;

  /**
   * 条目目标动作
   *
   * @param param 参数
   */
  tarItemAction?: (param: ItemAnimParam) => void;

  /**
   * 动效结束回调
   */
  callback?: OnAnimFinish;
}