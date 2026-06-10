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
  SCBSceneContainerSession,
  SCBSceneInfo,
  SCBScenePanelManager,
  SCBSceneSession,
  SCBSceneSessionManager,
  SCBScreenProperty,
  SCBTransitionController
} from '@ohos/windowscene';
import { describe, it, expect } from '@ohos/hypium'
import { OverlayStartAnimHelper } from '../../../../../../Index';
import { IOverlayCard, OverlayCardInfo, OverlayAnimScene } from '../../../../../main/ets/overlay/OverlayCardInfo';
import { OverlayTransitionParam } from '../../../../../main/ets/overlay/OverlayStartAnimHelper';
import { LiveViewCommonConstants, DefaultPanelZIndex } from '../../../../../main/ets/TsIndex';

export default function OverlayStartAnimHelperTest() {
  describe('OverlayStartAnimHelperTest', (): void => {

    it('startAnimPre', 0, () => {
      try {
        let helper = () => {
          OverlayStartAnimHelper.startAnimPre(getCardInfo(), OverlayAnimScene.TYPE_START_APP_FROM_LOCK_SCREEN);
          throw new Error('startAnimPre');
        }
        expect(helper()).assertThrowError('startAnimPre');
      } catch (e) {
      }
    })

    it('checkStartOverlayTransitionIn', 0, () => {
      try {
        let helper = () => {
          let cardInfo: IOverlayCard = getCardInfo();
          let overlayInfo = new OverlayCardInfo(cardInfo?.animType, cardInfo.cardBgId, cardInfo.cardContentId);
          let controller: SCBTransitionController = getSCBTransitionController(overlayInfo);
          let scbSceneInfo: SCBSceneInfo = new SCBSceneInfo('bundleName', 'moduleName', 'abilityName');
          let primarySession: SCBSceneSession = new SCBSceneSession(SCBSceneSessionManager.getInstance()
            .requestSceneSession(scbSceneInfo), scbSceneInfo);
          let scbSceneContainer: SCBSceneContainerSession =
            new SCBSceneContainerSession(primarySession, new SCBScreenProperty());
          let param: OverlayTransitionParam = {
            transitionController: controller,
            containerSession: scbSceneContainer,
            scenePanelManager: new SCBScenePanelManager,
            triggerType: ''
          }
          OverlayStartAnimHelper.checkStartOverlayTransitionIn(param);
          throw new Error('checkStartOverlayTransitionIn');
        }
        expect(helper()).assertThrowError('checkStartOverlayTransitionIn');
      } catch (e) {
      }
    })
  })
}

function getCardInfo(): IOverlayCard {
  let cardInfo: IOverlayCard = {
    animScene: OverlayAnimScene.TYPE_START_APP_FROM_LOCK_SCREEN,
    cardBgId: 'NTF_single_item_notification_center_111',
    cardContentId: 'NTF_single_item_notification_center_111',
    startBundleName: 'test',
    oriPanelZIndex: DefaultPanelZIndex.PANEL_SCREEN_LOCK,
    cardBgColor: LiveViewCommonConstants.ITEM_LOCK_NTF_BG_COLOR,
    cardBgBackdropBlur: 300,
    cardBgBlurStyle: BlurStyle.Thick,
  }
  return cardInfo;
}

function getSCBTransitionController(overlayInfo: OverlayCardInfo): SCBTransitionController {
  let controller: SCBTransitionController = {
    appData: {
      bundleName: '',
      abilityName: '',
      appIconId: '',
      iconRadius: 0,
      appIconNumber: 0,
    },
    overlayCardInfo: overlayInfo,
    onInactive: () => {
    },
    onActive: () => {
    }
  };
  return controller;
}