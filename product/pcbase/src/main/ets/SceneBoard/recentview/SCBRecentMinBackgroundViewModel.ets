/**
 * Copyright (c) 2024-2024 Huawei Device Co., Ltd.
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
  LogDomain,
  LogHelper,
  CommonUtils,
  SingleBase,
  SingleContext,
  singleManager
} from '@ohos/basicutils';
import {
  SCBSceneSession,
  SCBScreenProperty,
  SCBSceneContainerSession,
  SCBRecentSessionInfo
} from '@ohos/windowscene';
import { SCBRecentStyleConstants } from './SCBRecentStyleConstants';
import { SCBRecentSessionsViewModel } from './SCBRecentSessionsViewModel';
import { SCBRecentCardViewModel } from './SCBRecentCardViewModel';


const TAG = 'SCBRecentMinBackgroundViewModel';
const log = LogHelper.getLogHelper(LogDomain.RECENT, TAG);

export class SCBRecentMinBackgroundViewModel extends SingleBase {
  public static singleName: string = 'SCBRecentMinBackgroundViewModel';
  private static screen2ViewModel: Map<number, SCBRecentMinBackgroundViewModel> =
    new Map<number, SCBRecentMinBackgroundViewModel>();
  private screenProperty?: SCBScreenProperty;

  public constructor(ctx?: SingleContext) {
    super(ctx);
  }

  public static getInstance(screenProperty: SCBScreenProperty, ctx?: SingleContext): SCBRecentMinBackgroundViewModel {
    if (screenProperty && SCBRecentMinBackgroundViewModel.screen2ViewModel.has(screenProperty.screenId)) {
      return SCBRecentMinBackgroundViewModel.screen2ViewModel.get(screenProperty.screenId) as
        SCBRecentMinBackgroundViewModel;
    }
    let instance = new SCBRecentMinBackgroundViewModel(ctx);
    instance.initScreenProperty(screenProperty);
    SCBRecentMinBackgroundViewModel.screen2ViewModel.set(screenProperty.screenId, instance);
    log.showInfo(`getInstance new create ${screenProperty.screenId}`);
    return instance;
  }

  public initScreenProperty(screenProperty: SCBScreenProperty) {
    this.screenProperty = screenProperty;
  }

  public static deleteInstance(minBackgroundViewModel: SCBRecentMinBackgroundViewModel): void {
   if (minBackgroundViewModel && minBackgroundViewModel.screenProperty?.screenId) {
     SCBRecentMinBackgroundViewModel.screen2ViewModel.delete(minBackgroundViewModel.screenProperty.screenId);
   }
  }

  private getMinWidthBackgroundWidth(): number {
    return SCBRecentStyleConstants.CARD_TITLE_MIN_WIDTH;
  }

  private getMinHeightBackgroundHeight(): number {
    return SCBRecentSessionsViewModel.getInstance(this.singleContext).getRecentCardMinHeight();
  }

  public isNeedShowRecentMinBackground(sceneContainerSession: SCBSceneContainerSession,
    recentSessionInfo: SCBRecentSessionInfo): boolean {
    if (SCBRecentCardViewModel.isRecentCardMinWidth(sceneContainerSession, recentSessionInfo)) {
      log.showInfo(`container ${sceneContainerSession.getName()} less than min width.`);
      return true;
    }
    if (SCBRecentCardViewModel.isRecentCardMinHeight(recentSessionInfo, this?.screenProperty?.screenId ?? 0)) {
      log.showInfo(`container ${sceneContainerSession.getName()} less than min height.`);
      return true;
    }
    return false;
  }

  public buildRecentMinBackground(sceneContainerSession: SCBSceneContainerSession, reason: string): void {
    if (sceneContainerSession && !sceneContainerSession.dividerParam.isSplitRecentPair) {
      sceneContainerSession.needRenderRecentMinBackgroundShow.setPrimarySessionShowWithDfx(true, TAG, reason,
        sceneContainerSession.getName());
    }
  }

  public destroyRecentMinBackground(sceneContainerSession: SCBSceneContainerSession, reason: string): void {
    if (sceneContainerSession) {
      sceneContainerSession.needRenderRecentMinBackgroundShow.setPrimarySessionShowWithDfx(false, TAG, reason,
        sceneContainerSession.getName());
      sceneContainerSession.needRenderRecentMinBackgroundShow.secondSessionShow = false;
    }
  }

  private setMinBackgroundSize(sceneContainerSession: SCBSceneContainerSession, width: number, height: number,
    reason?: string): void {
    const name = sceneContainerSession.getName();
    sceneContainerSession.needRenderRecentMinBackgroundSize.setWidthWithDfx(width, TAG, reason, name);
    sceneContainerSession.needRenderRecentMinBackgroundSize.setHeightWithDfx(height, TAG, reason, name);
  }

  public setMinBackgroundAlpha(sceneContainerSession: SCBSceneContainerSession, alpha: number): void {
    if (sceneContainerSession) {
      sceneContainerSession.needRenderRecentMinBackgroundAlpha.setAlpha(alpha);
    }
  }

  public enterRecentAnimatePrepare(sceneContainerSession: SCBSceneContainerSession,
    recentSessionInfo: SCBRecentSessionInfo): void {
    if (!sceneContainerSession) {
      return;
    }
    if (!this.isNeedShowRecentMinBackground(sceneContainerSession, recentSessionInfo)) {
      return;
    }

    const animateFromWidth = SCBRecentCardViewModel.getSceneContainerWidthPrepareEnterRecent(sceneContainerSession);
    const animateFromHeight = SCBRecentCardViewModel.getSceneContainerHeightPrepareEnterRecent(sceneContainerSession);
    this.setMinBackgroundAlpha(sceneContainerSession, 0);
    this.buildRecentMinBackground(sceneContainerSession, 'enter recent prepare');

    SCBRecentCardViewModel.hideSceneShadow(sceneContainerSession);
    SCBRecentCardViewModel.hideSceneStroke(sceneContainerSession);
  }

  public enterRecentAnimateEvent(sceneContainerSession: SCBSceneContainerSession,
    recentSessionInfo: SCBRecentSessionInfo): void {
    if (!sceneContainerSession) {
      return;
    }
    if (!this.isNeedShowRecentMinBackground(sceneContainerSession, recentSessionInfo)) {
      return;
    }
    // min background width and height
    if (SCBRecentCardViewModel.isRecentCardMinHeight(recentSessionInfo, this?.screenProperty?.screenId ?? 0)) {
      const animateToWidth = recentSessionInfo.width;
      const animateToHeight = this.getMinHeightBackgroundHeight();
      this.setMinBackgroundSize(sceneContainerSession, animateToWidth, animateToHeight, 'enter recent event');
    } else if (SCBRecentCardViewModel.isRecentCardMinWidth(sceneContainerSession, recentSessionInfo)) {
      const animateToWidth = this.getMinWidthBackgroundWidth();
      const animateToHeight = recentSessionInfo.height;
      this.setMinBackgroundSize(sceneContainerSession, animateToWidth, animateToHeight, 'enter recent event');
    }
    // min background alpha from 0 to 1
    this.setMinBackgroundAlpha(sceneContainerSession, 1);
  }

  public setMinBackgroundSizeWhenRecentLayoutChange(sceneContainerSession: SCBSceneContainerSession,
    recentSessionInfo: SCBRecentSessionInfo): void {
    if (!sceneContainerSession) {
      return;
    }
    if (!this.isNeedShowRecentMinBackground(sceneContainerSession, recentSessionInfo)) {
      return;
    }
    if (SCBRecentCardViewModel.isRecentCardMinHeight(recentSessionInfo, this?.screenProperty?.screenId ?? 0)) {
      const animateToWidth = recentSessionInfo.width;
      const animateToHeight = this.getMinHeightBackgroundHeight();
      this.setMinBackgroundSize(sceneContainerSession, animateToWidth, animateToHeight, 'recent layout change');
    } else if (SCBRecentCardViewModel.isRecentCardMinWidth(sceneContainerSession, recentSessionInfo)) {
      const animateToWidth = this.getMinWidthBackgroundWidth();
      const animateToHeight = recentSessionInfo.height;
      this.setMinBackgroundSize(sceneContainerSession, animateToWidth, animateToHeight, 'recent layout change');
    }
  }

  public enterRecentWithoutAnimate(sceneContainerSession: SCBSceneContainerSession,
    recentSessionInfo: SCBRecentSessionInfo): void {
    if (!sceneContainerSession) {
      return;
    }
    if (!this.isNeedShowRecentMinBackground(sceneContainerSession, recentSessionInfo)) {
      this.setMinBackgroundAlpha(sceneContainerSession, 0);
      this.destroyRecentMinBackground(sceneContainerSession, 'enterRecentWithoutAnimate');
      return;
    }
    if (SCBRecentCardViewModel.isRecentCardMinHeight(recentSessionInfo, this?.screenProperty?.screenId ?? 0)) {
      const animateToWidth = recentSessionInfo.width;
      const animateToHeight = this.getMinHeightBackgroundHeight();
      this.setMinBackgroundSize(sceneContainerSession, animateToWidth, animateToHeight, 'enter recent without animate');
    } else if (SCBRecentCardViewModel.isRecentCardMinWidth(sceneContainerSession, recentSessionInfo)) {
      const animateToWidth = this.getMinWidthBackgroundWidth();
      const animateToHeight = recentSessionInfo.height;
      this.setMinBackgroundSize(sceneContainerSession, animateToWidth, animateToHeight, 'enter recent without animate');
    }
    this.setMinBackgroundAlpha(sceneContainerSession, 1);
    SCBRecentCardViewModel.hideSceneShadow(sceneContainerSession);
    SCBRecentCardViewModel.hideSceneStroke(sceneContainerSession);
    this.buildRecentMinBackground(sceneContainerSession, 'enter recent without animate');
  }

  public setMinBackgroundSizeWhenExitRecentToFg(sceneContainerSession: SCBSceneContainerSession,
    recentSessionInfo: SCBRecentSessionInfo): void {
    if (!sceneContainerSession) {
      return;
    }
    if (!this.isNeedShowRecentMinBackground(sceneContainerSession, recentSessionInfo)) {
      return;
    }
    if (SCBRecentCardViewModel.isRecentCardMinHeight(recentSessionInfo, this?.screenProperty?.screenId ?? 0)) {
      const animateToWidth = sceneContainerSession.getSceneContainerWidth();
      const animateToHeight = Math.min(sceneContainerSession.getSceneContainerHeight(),
        this.getMinHeightBackgroundHeight());
    } else if (SCBRecentCardViewModel.isRecentCardMinWidth(sceneContainerSession, recentSessionInfo)) {
      const animateToWidth = Math.min(sceneContainerSession.getSceneContainerWidth(),
        this.getMinWidthBackgroundWidth());
      const animateToHeight = sceneContainerSession.getSceneContainerHeight();
    }
  }

  public setMinBackgroundSizeWhenExitRecentToBg(sceneContainerSession: SCBSceneContainerSession,
    recentSessionInfo: SCBRecentSessionInfo): void {
    if (!sceneContainerSession) {
      return;
    }
    if (!this.isNeedShowRecentMinBackground(sceneContainerSession, recentSessionInfo)) {
      return;
    }
    if (SCBRecentCardViewModel.isRecentCardMinHeight(recentSessionInfo, this?.screenProperty?.screenId ?? 0)) {
      const animateToWidth = recentSessionInfo.width * SCBRecentStyleConstants.RECENT_ANIM_RATIO;
      const animateToHeight = Math.min(sceneContainerSession.getSceneContainerHeight(),
        this.getMinHeightBackgroundHeight());
      this.setMinBackgroundSize(sceneContainerSession, animateToWidth, animateToHeight, 'exit recent to bg event');
    } else if (SCBRecentCardViewModel.isRecentCardMinWidth(sceneContainerSession, recentSessionInfo)) {
      const animateToWidth = Math.min(sceneContainerSession.getSceneContainerWidth(),
        this.getMinWidthBackgroundWidth());
      const animateToHeight = recentSessionInfo.height * SCBRecentStyleConstants.RECENT_ANIM_RATIO;
      this.setMinBackgroundSize(sceneContainerSession, animateToWidth, animateToHeight, 'exit recent to bg event');
    }
  }

  public exitRecentWithoutAnimate(sceneContainerSession: SCBSceneContainerSession,
    recentSessionInfo: SCBRecentSessionInfo): void {
    this.setMinBackgroundSizeWhenExitRecentToBg(sceneContainerSession, recentSessionInfo);
    this.setMinBackgroundAlpha(sceneContainerSession, 0);
    this.destroyRecentMinBackground(sceneContainerSession, 'exit recent without animate');
  }
}
