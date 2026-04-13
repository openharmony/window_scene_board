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
import { describe, it, expect } from '@ohos/hypium';
import { AnimParam } from '../../../../../../main/ets/liveview/common/LiveItemStartAnimManager';
import { StartAbilityOverlayAnimate } from '../../../../../../main/ets/liveview/common/StartAbilityOverlayAnimate';
import {
  StartAbilityOverlayAnimateData
} from '../../../../../../main/ets/liveview/common/StartAbilityOverlayAnimateData';
import { CardBorderRadius, LiveUseScene } from '../../../../../../main/ets/TsIndex';

export default function StartAbilityOverlayAnimateTest() {
  describe('StartAbilityOverlayAnimateTest', (): void => {
    it('initData', 0, () => {
      let res = true;
      let startAnim: StartAbilityOverlayAnimate = StartAbilityOverlayAnimate.getInstance();
      let data: StartAbilityOverlayAnimateData = new StartAbilityOverlayAnimateData();
      startAnim.initData(data);
      expect(res).assertTrue();
    })

    it('prepareForOverlayAnimate', 0, () => {
      let res = true;
      let startAnim: StartAbilityOverlayAnimate = StartAbilityOverlayAnimate.getInstance();
      startAnim.prepareForOverlayAnimate(getAnimParam());
      expect(res).assertTrue();
    })

    it('onOverlayAnimateStart', 0, () => {
      let res = true;
      let startAnim: StartAbilityOverlayAnimate = StartAbilityOverlayAnimate.getInstance();
      let data: StartAbilityOverlayAnimateData = new StartAbilityOverlayAnimateData();
      startAnim.initData(data);
      startAnim.onOverlayAnimateStart();
      expect(res).assertTrue();
    })

    it('getItemContentId', 0, () => {
      let res = true;
      let startAnim: StartAbilityOverlayAnimate = StartAbilityOverlayAnimate.getInstance();
      let id: string = startAnim.getItemContentId(getAnimParam());
      expect(id).assertEqual('test');
    })

    it('getItemRadius', 0, () => {
      let startAnim: StartAbilityOverlayAnimate = StartAbilityOverlayAnimate.getInstance();
      let cardRadius: CardBorderRadius = startAnim.getItemRadius(getAnimParam());
      expect(cardRadius.topLeft).assertEqual(16);
    })
  });
}

function getAnimParam(): AnimParam {
  let startAgent = (hasAnim: boolean = true) => {};
  let param: AnimParam = {
    cardId: 'xxxxx',
    startBundleName: 'test.com',
    cardComponentId: 'test',
    cardRadius: undefined,
    scene: LiveUseScene.SCENE_SCREEN_LOCK_NOTIFICATION,
    onPreComplete: startAgent
  }
  return param;
}