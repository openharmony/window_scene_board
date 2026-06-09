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

import { describe, it, expect } from '@ohos/hypium';
import { DockItemInfo } from '@ohos/launchercommon';
import { PcModeMenuEvent, PcModePopupEvent } from '../../../../main/ets/default/pcmode/viewmodel/PcModeMenuAndPopupEvent';
import { PcModeMenuVm, PcModePopupVm } from '../../../../main/ets/default/pcmode/viewmodel/PcModeMenuAndPopupVm';
import { DockItemAnimationVm } from '../../../../main/ets/default/viewmodel/DockItemAnimationVm';

export default function PcModeMenuAndPopupEventTest() {
  describe('PcModeMenuAndPopupEventTest', () => {
    it('onMenuAppearTest001', 0, () => {
      const menuVm: PcModeMenuVm = new PcModeMenuVm();
      const popupVm: PcModePopupVm = new PcModePopupVm();
      const animationVm: DockItemAnimationVm = new DockItemAnimationVm();
      let menuEvent: PcModeMenuEvent = new PcModeMenuEvent(menuVm, popupVm, animationVm);
      menuEvent.onMenuAppear();
      expect(menuVm.isMenuShow).assertEqual(true);
    });
    it('onMenuDisappearTest001', 0, () => {
      const menuVm: PcModeMenuVm = new PcModeMenuVm();
      const popupVm: PcModePopupVm = new PcModePopupVm();
      const animationVm: DockItemAnimationVm = new DockItemAnimationVm();
      let menuEvent: PcModeMenuEvent = new PcModeMenuEvent(menuVm, popupVm, animationVm);
      menuEvent.onMenuDisappear();
      expect(menuVm.isMenuShow).assertEqual(false);
    });
    it('setMenuShowStatusTest002', 0, () => {
      const menuVm: PcModeMenuVm = new PcModeMenuVm();
      const popupVm: PcModePopupVm = new PcModePopupVm();
      const animationVm: DockItemAnimationVm = new DockItemAnimationVm();
      let menuEvent: PcModeMenuEvent = new PcModeMenuEvent(menuVm, popupVm, animationVm);
      menuEvent.setMenuShowStatus(true);
      expect(AppStorage.get('isDockMissionsPopupShow')).assertEqual(false);
    });
    it('setMenuShowStatusTest003', 0, () => {
      const menuVm: PcModeMenuVm = new PcModeMenuVm();
      const popupVm: PcModePopupVm = new PcModePopupVm();
      const animationVm: DockItemAnimationVm = new DockItemAnimationVm();
      let menuEvent: PcModeMenuEvent = new PcModeMenuEvent(menuVm, popupVm, animationVm);
      menuEvent.setMenuShowStatus(false);
      expect(AppStorage.get('isDockMenuShow')).assertEqual(false);
    });
    it('onTouchDown001', 0, () => {
      const menuVm: PcModeMenuVm = new PcModeMenuVm();
      const popupVm: PcModePopupVm = new PcModePopupVm();
      const animationVm: DockItemAnimationVm = new DockItemAnimationVm();
      let menuEvent: PcModeMenuEvent = new PcModeMenuEvent(menuVm, popupVm, animationVm);
      menuEvent.onTouchDown();
      expect(menuEvent instanceof PcModeMenuEvent).assertTrue();
    });
    it('onTouchUp001', 0, () => {
      const menuVm: PcModeMenuVm = new PcModeMenuVm();
      const popupVm: PcModePopupVm = new PcModePopupVm();
      const animationVm: DockItemAnimationVm = new DockItemAnimationVm();
      let menuEvent: PcModeMenuEvent = new PcModeMenuEvent(menuVm, popupVm, animationVm);
      menuEvent.onTouchUp();
      expect(menuEvent instanceof PcModeMenuEvent).assertTrue();
    });
    it('init001', 0, () => {
      const menuVm: PcModeMenuVm = new PcModeMenuVm();
      const popupVm: PcModePopupVm = new PcModePopupVm();
      let menuEvent: PcModePopupEvent = new PcModePopupEvent(popupVm, menuVm);
      const item: DockItemInfo = new DockItemInfo();
      menuEvent.init(item);
      expect(menuEvent instanceof PcModePopupEvent).assertTrue();
    });
    it('destroy001', 0, () => {
      const menuVm: PcModeMenuVm = new PcModeMenuVm();
      const popupVm: PcModePopupVm = new PcModePopupVm();
      let menuEvent: PcModePopupEvent = new PcModePopupEvent(popupVm, menuVm);
      const item: DockItemInfo = new DockItemInfo();
      menuEvent.destroy(item);
      expect(menuEvent instanceof PcModePopupEvent).assertTrue();
    });
    it('onHoverAppItem001', 0, () => {
      const menuVm: PcModeMenuVm = new PcModeMenuVm();
      const popupVm: PcModePopupVm = new PcModePopupVm();
      let menuEvent: PcModePopupEvent = new PcModePopupEvent(popupVm, menuVm);
      const item: DockItemInfo = new DockItemInfo();
      menuEvent.onHoverAppItem(true, item);
      expect(menuEvent instanceof PcModePopupEvent).assertTrue();
    });
    it('onHoverAppItem002', 0, () => {
      const menuVm: PcModeMenuVm = new PcModeMenuVm();
      const popupVm: PcModePopupVm = new PcModePopupVm();
      let menuEvent: PcModePopupEvent = new PcModePopupEvent(popupVm, menuVm);
      const item: DockItemInfo = new DockItemInfo();
      menuEvent.onHoverAppItem(false, item);
      expect(menuEvent instanceof PcModePopupEvent).assertTrue();
    });
    it('popupShowJudge001', 0, () => {
      const menuVm: PcModeMenuVm = new PcModeMenuVm();
      const popupVm: PcModePopupVm = new PcModePopupVm();
      let menuEvent: PcModePopupEvent = new PcModePopupEvent(popupVm, menuVm);
      const item: DockItemInfo = new DockItemInfo();
      menuEvent.popupShowJudge(item);
      expect(menuEvent instanceof PcModePopupEvent).assertTrue();
    });
    it('updatePopupData001', 0, () => {
      const menuVm: PcModeMenuVm = new PcModeMenuVm();
      const popupVm: PcModePopupVm = new PcModePopupVm();
      let menuEvent: PcModePopupEvent = new PcModePopupEvent(popupVm, menuVm);
      const item: DockItemInfo = new DockItemInfo();
      menuEvent.updatePopupData(item, true, '', () => {});
      expect(menuEvent instanceof PcModePopupEvent).assertTrue();
    });
    it('updatePopupData002', 0, () => {
      const menuVm: PcModeMenuVm = new PcModeMenuVm();
      const popupVm: PcModePopupVm = new PcModePopupVm();
      let menuEvent: PcModePopupEvent = new PcModePopupEvent(popupVm, menuVm);
      const item: DockItemInfo = new DockItemInfo();
      menuEvent.updatePopupData(item, false, '', () => {});
      expect(menuEvent instanceof PcModePopupEvent).assertTrue();
    });
    it('popupHide001', 0, () => {
      const menuVm: PcModeMenuVm = new PcModeMenuVm();
      const popupVm: PcModePopupVm = new PcModePopupVm();
      let menuEvent: PcModePopupEvent = new PcModePopupEvent(popupVm, menuVm);
      menuEvent.popupHide();
      expect(menuEvent instanceof PcModePopupEvent).assertTrue();
    });
    it('onItemPopupStateChange001', 0, () => {
      const menuVm: PcModeMenuVm = new PcModeMenuVm();
      const popupVm: PcModePopupVm = new PcModePopupVm();
      let menuEvent: PcModePopupEvent = new PcModePopupEvent(popupVm, menuVm);
      const item: DockItemInfo = new DockItemInfo();
      menuEvent.onItemPopupStateChange(true, item);
      expect(menuEvent instanceof PcModePopupEvent).assertTrue();
    });
    it('onItemPopupStateChange002', 0, () => {
      const menuVm: PcModeMenuVm = new PcModeMenuVm();
      const popupVm: PcModePopupVm = new PcModePopupVm();
      let menuEvent: PcModePopupEvent = new PcModePopupEvent(popupVm, menuVm);
      const item: DockItemInfo = new DockItemInfo();
      menuEvent.onItemPopupStateChange(false, item);
      expect(menuEvent instanceof PcModePopupEvent).assertTrue();
    });
  })
}