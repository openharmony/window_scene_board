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

import { afterAll, afterEach, beforeAll, beforeEach, describe, expect, it } from '@ohos/hypium';
import { ClockWidgetAnimManager, ClockAnimParam } from '@ohos/screenlockwidget/src/main/ets/clock/viewmodel/viewanim/ClockWidgetAnimManager';
import { ClockStaticData } from '@ohos/screenlockwidget/src/main/ets/clock/model/data/ClockStaticData';
import { ClockBindData } from '@ohos/screenlockwidget/src/main/ets/clock/model/data/ClockBindData';
import { ClockLayoutModifier } from '@ohos/screenlockwidget/src/main/ets/clock/common/ClockLayoutModifier';
import { AnimationStateListener } from '@ohos/screenlockwidget/src/main/ets/common/utils/AnimationUtil';
import { ClockAnimData } from '@ohos/screenlockwidget/src/main/ets/clock/model/data/ClockAnimData';

export default function ClockWidgetAnimManagerTest() {
  let staticState: ClockStaticData = new ClockStaticData();
  let bindState: ClockBindData = new ClockBindData();
  let clockAnimData: ClockAnimData = new ClockAnimData();
  let clockLayoutModifier: ClockLayoutModifier = new ClockLayoutModifier(bindState);
  let animationStateListener: AnimationStateListener = {
    onAnimationStart: (): void => {},
    onAnimationEnd: (): void => {}
  };
  describe('ClockWidgetAnimManagerTest', (): void => {

    let mClockWidgetAnimManager: ClockWidgetAnimManager = new ClockWidgetAnimManager(staticState, bindState,
      clockAnimData, clockLayoutModifier);

    let animPreParam: AnimPrepareParam = {
      mainAnimScene: AnimScene.SCENE_MAIN_COLLAPSE,
      sepAlphaScene: AnimScene.SCENE_SEP_ALPHA_COLLAPSE,
      isTimeSeparate: true,
      isPreSeparateShow: true,
      isCurSeparateShow: true,
      isPreSeparateLine: false,
      isCurSeparateLine: true,
      isPreLargeDate: true,
      isCurLargeDate: false
    };

    beforeAll((): void => {
    })

    beforeEach((): void => {
    })

    afterEach((): void => {
    })

    afterAll((): void => {
    })

    it('test_getClockAnimData_return', 0, (): void => {
      let res = mClockWidgetAnimManager.getClockAnimData();
      expect(res).not().assertNull();
    });

    it('test_startCollapseStateChangeAnim_undefined', 0, (): void => {
      mClockWidgetAnimManager.startCollapseStateChangeAnim({
        isAnimToExpand: true,
        animListener: undefined,
      });
      expect(mClockWidgetAnimManager).not().assertNull();
    });

    it('test_startCollapseStateChangeAnim_defined', 0, (): void => {
      mClockWidgetAnimManager.startCollapseStateChangeAnim({
        isAnimToExpand: true,
        animListener: animationStateListener,
      });

      let staticState2: ClockStaticData = new ClockStaticData();
      staticState2.updateGridAndElementConf();
      let bindState2: ClockBindData = new ClockBindData();
      let clockAnimData2: ClockAnimData = new ClockAnimData();
      let mClockWidgetAnimManager2: ClockWidgetAnimManager = new ClockWidgetAnimManager(staticState, bindState,
        clockAnimData, clockLayoutModifier);
      mClockWidgetAnimManager2.startCollapseStateChangeAnim({
        isAnimToExpand: true,
        animListener: animationStateListener,
      });
      expect(mClockWidgetAnimManager).not().assertNull();
    });

    it('test_onClockAnimInterruptListener', 0, (): void => {
      (mClockWidgetAnimManager as object)['onClockAnimInterruptListener']();
      expect(mClockWidgetAnimManager).not().assertNull();
    });

    it('test_startAllElementAnim', 0, (): void => {
      (mClockWidgetAnimManager as object)['startAllElementAnim'](animPreParam);
      animPreParam.isTimeSeparate = false;
      (mClockWidgetAnimManager as object)['startAllElementAnim'](animPreParam);
      expect(mClockWidgetAnimManager).not().assertNull();
    });

    it('test_initMainSpringAnim', 0, (): void => {
      (mClockWidgetAnimManager as object)['initMainSpringAnim'](animPreParam);
      expect(mClockWidgetAnimManager).not().assertNull();
    });

    it('test_initLineAlphaAnim', 0, (): void => {
      animPreParam.isCurSeparateShow = false;
      animPreParam.isCurSeparateLine = true;
      (mClockWidgetAnimManager as object)['initLineAlphaAnim'](animPreParam);
      animPreParam.isCurSeparateLine = false;
      (mClockWidgetAnimManager as object)['initLineAlphaAnim'](animPreParam);
      animPreParam.isCurSeparateShow = true;
      (mClockWidgetAnimManager as object)['initLineAlphaAnim'](animPreParam);
      expect(mClockWidgetAnimManager).not().assertNull();
    });

    it('test_initPointAlphaAnim', 0, (): void => {
      animPreParam.isCurSeparateShow = true;
      animPreParam.isCurSeparateShow = false;
      animPreParam.isCurSeparateLine = true;
      (mClockWidgetAnimManager as object)['initPointAlphaAnim'](animPreParam);
      animPreParam.isCurSeparateLine = false;
      (mClockWidgetAnimManager as object)['initPointAlphaAnim'](animPreParam);
      animPreParam.isCurSeparateShow = true;
      animPreParam.isCurSeparateShow = true;
      (mClockWidgetAnimManager as object)['initPointAlphaAnim'](animPreParam);
      expect(mClockWidgetAnimManager).not().assertNull();
    });

    it('test_updateDateWeekLunarStyle', 0, (): void => {
      (mClockWidgetAnimManager as object)['updateDateWeekLunarStyle']();
      expect(mClockWidgetAnimManager).not().assertNull();
    });

    it('test_updateClockGridParam', 0, (): void => {
      (mClockWidgetAnimManager as object)['updateClockGridParam']();
      expect(mClockWidgetAnimManager).not().assertNull();
    });

    it('test_updateElement', 0, (): void => {
      (mClockWidgetAnimManager as object)['updateElement'](undefined, [1, 2]);
      (mClockWidgetAnimManager as object)['updateElement'](undefined, undefined);
      expect(mClockWidgetAnimManager).not().assertNull();
    });

    it('test_getMainSpringAnimListener', 0, (): void => {
      (mClockWidgetAnimManager as object)['getMainSpringAnimListener'](animPreParam);
      expect(mClockWidgetAnimManager).not().assertNull();
    });

    it('test_getSeparatorAlphaListener', 0, (): void => {
      (mClockWidgetAnimManager as object)['getSeparatorAlphaListener'](AnimScene.SCENE_MAIN_COLLAPSE);
      (mClockWidgetAnimManager as object)['getSeparatorAlphaListener'](AnimScene.SCENE_MAIN_EXPAND);
      (mClockWidgetAnimManager as object)['getSeparatorAlphaListener'](AnimScene.SCENE_SEP_ALPHA_COLLAPSE);
      (mClockWidgetAnimManager as object)['getSeparatorAlphaListener'](AnimScene.SCENE_SEP_ALPHA_EXPAND);
      expect(mClockWidgetAnimManager).not().assertNull();
    });

    it('test_isAnimCollapse', 0, (): void => {
      animPreParam.mainAnimScene = AnimScene.SCENE_MAIN_COLLAPSE;
      (mClockWidgetAnimManager as object)['isAnimCollapse'](animPreParam);
      animPreParam.mainAnimScene = AnimScene.SCENE_SEP_ALPHA_COLLAPSE;
      (mClockWidgetAnimManager as object)['isAnimCollapse'](animPreParam);
      expect(mClockWidgetAnimManager).not().assertNull();
    });

    it('test_getAnimPrepareParam', 0, (): void => {
      (mClockWidgetAnimManager as object)['getAnimPrepareParam']({
        isAnimToExpand: false,
        animListener: animationStateListener
      });
      expect(mClockWidgetAnimManager).not().assertNull();
    });

    it('test_getAnimCurve', 0, (): void => {
      (mClockWidgetAnimManager as object)['getAnimCurve'](AnimParamType.MAIN_SPRING);
      (mClockWidgetAnimManager as object)['getAnimCurve'](AnimParamType.SECONDARY_CUBIC_BEZIER);
      (mClockWidgetAnimManager as object)['getAnimCurve'](AnimParamType.MAIN_SPRING, 0);
      (mClockWidgetAnimManager as object)['getAnimCurve'](AnimParamType.SECONDARY_CUBIC_BEZIER, 0);
      (mClockWidgetAnimManager as object)['getAnimCurve'](AnimParamType.MAIN_SPRING, 1);
      (mClockWidgetAnimManager as object)['getAnimCurve'](AnimParamType.SECONDARY_CUBIC_BEZIER, 1);
      expect(mClockWidgetAnimManager).not().assertNull();
    });

    it('test_addAnimListener', 0, (): void => {
      (mClockWidgetAnimManager as object)['addAnimListener'](AnimScene.SCENE_MAIN_COLLAPSE, animationStateListener);
      (mClockWidgetAnimManager as object)['addAnimListener'](AnimScene.SCENE_MAIN_EXPAND, animationStateListener);
      (mClockWidgetAnimManager as object)['addAnimListener'](AnimScene.SCENE_SEP_ALPHA_COLLAPSE, animationStateListener);
      (mClockWidgetAnimManager as object)['addAnimListener'](AnimScene.SCENE_SEP_ALPHA_EXPAND, animationStateListener);
      expect(mClockWidgetAnimManager).not().assertNull();
    });

    it('test_removeAnimListener', 0, (): void => {
      (mClockWidgetAnimManager as object)['removeAnimListener'](AnimScene.SCENE_MAIN_COLLAPSE);
      (mClockWidgetAnimManager as object)['removeAnimListener'](AnimScene.SCENE_MAIN_EXPAND);
      (mClockWidgetAnimManager as object)['removeAnimListener'](AnimScene.SCENE_SEP_ALPHA_COLLAPSE);
      (mClockWidgetAnimManager as object)['removeAnimListener'](AnimScene.SCENE_SEP_ALPHA_EXPAND);
      expect(mClockWidgetAnimManager).not().assertNull();
    });

    it('test_hasAnimListener', 0, (): void => {
      (mClockWidgetAnimManager as object)['hasAnimListener'](AnimScene.SCENE_MAIN_COLLAPSE);
      (mClockWidgetAnimManager as object)['hasAnimListener'](AnimScene.SCENE_MAIN_EXPAND);
      (mClockWidgetAnimManager as object)['hasAnimListener'](AnimScene.SCENE_SEP_ALPHA_COLLAPSE);
      (mClockWidgetAnimManager as object)['hasAnimListener'](AnimScene.SCENE_SEP_ALPHA_EXPAND);
      expect(mClockWidgetAnimManager).not().assertNull();
    });

    it('test_interceptAnimScene', 0, (): void => {
      (mClockWidgetAnimManager as object)['interceptAnimScene'](AnimScene.SCENE_MAIN_COLLAPSE);
      (mClockWidgetAnimManager as object)['interceptAnimScene'](AnimScene.SCENE_MAIN_EXPAND);
      (mClockWidgetAnimManager as object)['interceptAnimScene'](AnimScene.SCENE_SEP_ALPHA_COLLAPSE);
      (mClockWidgetAnimManager as object)['interceptAnimScene'](AnimScene.SCENE_SEP_ALPHA_EXPAND);
      expect(mClockWidgetAnimManager).not().assertNull();
    });

    it('test_startClockAnimState', 0, (): void => {
      (mClockWidgetAnimManager as object)['startClockAnimState']();
      expect(mClockWidgetAnimManager).not().assertNull();
    });

    it('test_endClockAnimState', 0, (): void => {
      (mClockWidgetAnimManager as object)['endClockAnimState']();
      expect(mClockWidgetAnimManager).not().assertNull();
    });

    it('test_resetClockAnimState', 0, (): void => {
      (mClockWidgetAnimManager as object)['resetClockAnimState']();
      expect(mClockWidgetAnimManager).not().assertNull();
    });

    it('test_hasClockTranY', 0, (): void => {
      (mClockWidgetAnimManager as object)['hasClockTranY']();
      expect(mClockWidgetAnimManager).not().assertNull();
    });

    it('test_getClockAnimState', 0, (): void => {
      (mClockWidgetAnimManager as object)['getClockAnimState']();
      expect(mClockWidgetAnimManager).not().assertNull();
    });

    it('test_startSeparatorAlphaAnim', 0, (): void => {
      animPreParam.isPreSeparateShow = false;
      animPreParam.isCurSeparateShow = false;
      (mClockWidgetAnimManager as object)['startSeparatorAlphaAnim'](animPreParam);
      animPreParam.isPreSeparateShow = true;
      animPreParam.isCurSeparateShow = true;
      animPreParam.isPreSeparateLine = true;
      animPreParam.isCurSeparateLine = true;
      (mClockWidgetAnimManager as object)['startSeparatorAlphaAnim'](animPreParam);
      animPreParam.isCurSeparateLine = false;
      (mClockWidgetAnimManager as object)['startSeparatorAlphaAnim'](animPreParam);
      expect(mClockWidgetAnimManager).not().assertNull();
    });
  })
}

interface AnimPrepareParam {
  mainAnimScene: AnimScene; // 主动效场景
  sepAlphaScene: AnimScene; // 分隔符透明度动效场景
  isTimeSeparate: boolean; // 小时分钟是否分散类型
  isPreSeparateShow: boolean; // 切换状态前分割符是否显示
  isCurSeparateShow: boolean; // 切换状态后分割符是否显示
  isPreSeparateLine: boolean; // 切换状态前是否为线分隔符
  isCurSeparateLine: boolean; // 切换状态后是否为线分隔符
  isPreLargeDate: boolean; // 切换状态前是否大日期样式
  isCurLargeDate: boolean; // 切换状态后是否大日期样式
  animListener?: AnimationStateListener; // 动效监听
}

/**
 * 动效曲线类型
 */
enum AnimParamType {
  MAIN_SPRING = 1, // 主动效弹簧曲线
  SECONDARY_CUBIC_BEZIER // 次动效贝塞尔曲线
}

enum AnimScene {
  SCENE_MAIN_COLLAPSE = 'main_spring_collapse', // 主动效收起场景
  SCENE_MAIN_EXPAND = 'main_spring_expand', // 主动效展开场景
  SCENE_SEP_ALPHA_COLLAPSE = 'separator_alpha_collapse', // 分隔符透明度收起场景
  SCENE_SEP_ALPHA_EXPAND = 'separator_alpha_expand' // 分隔符透明度展开场景
}