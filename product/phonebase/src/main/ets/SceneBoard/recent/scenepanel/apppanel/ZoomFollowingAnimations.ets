/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
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
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { SCBScenePanelManager } from '@ohos/windowscene';
import { RecentLayoutManager } from '../../common/RecentLayoutManager';
import { curves } from '@kit.ArkUI';
import { CommonConstants } from '@ohos/launchercommon';
import { gestureHelperInstance } from '../common/GestureHelper';

const TAG = 'ZoomFollowingAnimations';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);
export class ZoomFollowingAnimations {
  private readonly panelManager: SCBScenePanelManager;

  constructor(panelManager: SCBScenePanelManager) {
    this.panelManager = panelManager;
  }

  /**
   * updateAppZoomView 未触发多任务/快切时 应用手势跟手动效
   * @param gestureEvent 手势事件
   */
  public updateAppZoomView(gestureEvent: GestureEvent): void {
    let listLen = this.panelManager.getSceneContainerSessionList().length;
    if (listLen === 0) {
      log.showWarn('current container session list is 0.');
      return;
    }
    let screenH = px2vp(this.panelManager.getScreenProperty().height);
    let screenW = px2vp(this.panelManager.getScreenProperty().width);
    let currContainerSession = this.panelManager.getSceneContainerSessionList().getTopActiveSession();
    if (!currContainerSession) {
      let recentScale = RecentLayoutManager.getScale(this.panelManager.getScreenProperty());
      let recentMargin = RecentLayoutManager.getWidthSpace();
      this.panelManager.getViewParam().recentPadding = (1 - recentScale) * screenW / 2;
      this.panelManager.getViewParam().recentW =
        vp2px((listLen * screenW * recentScale + recentMargin * (listLen - 1)) +
          this.panelManager.getViewParam().recentPadding * 2);
      this.panelManager.getViewParam().recentTransX = 0;
      return;
    }
    let offsetX = gestureEvent.offsetX;
    let offsetY = gestureEvent.offsetY;
    let currScale = RecentLayoutManager.getFollowingScaleForApp(offsetY, screenH);
    let currTransY =
      RecentLayoutManager.getFollowingTranslateYForApp(offsetY, screenH, currContainerSession.needRenderScale.scaleY);
    let scaleTranslateX =
      RecentLayoutManager.getTranslateXByScaleAndTouchPosX(gestureEvent, currScale, screenW);
    let currTransX = offsetX * currScale + scaleTranslateX;
    animateTo({
      curve: curves.responsiveSpringMotion(0.1, 1, 0.25)
    }, () => {
      if (currContainerSession) {
        let nameDfx = currContainerSession.getName();
        currContainerSession.needRenderShowInRecent.setShowInRecentWithDfx(true, TAG, 'updateAppZoomView', nameDfx);
        currContainerSession.needRenderVisibility.setVisibilityWithDfx(true, TAG, 'updateAppZoomView', nameDfx);
        currContainerSession.needRenderTranslate.setTranslateX(currTransX);
        currContainerSession.needRenderScale.setScaleX(currScale);
        currContainerSession.needRenderScale.setScaleY(currScale);
        currContainerSession.needRenderTranslate.setTranslateY(currTransY);
        currContainerSession.needRenderBorderRadius.setBorderRadiusWithDfx(CommonConstants.getDeviceRadius(), TAG,
          'updateAppZoomView', nameDfx);
      }
    })
  }
}