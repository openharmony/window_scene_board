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

import sceneSessionManager from '@ohos.sceneSessionManager';
import {
  ACTIVE_STATUS_MAP,
  OccludeKeygaurdScene,
  SCBSceneSessionManager,
  SCBScreenProperty,
  SCBScreenSessionManager,
  SCBSpecificSceneSessionList,
  SCBSpecificSession,
  SpecificPanelZOrder,
  SystemSessionInfo,
  SCBPropertyChangeReason,
  SCBSessionRect,
  ScbNumber,
  SCBSpecificScenePanelDebugCommands,
} from '@ohos/windowscene';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { SceneConstants } from '@ohos/commonconstants';
import { SCBSpecificScene } from './SCBSpecificScene';
import { SCBDefaultZIndex, ZORDER_TO_DEFAULTZINDEX } from './SCBScreen';
import { SCBSpecificScenePanelViewModel } from './viewmodel/SCBSpecificScenePanelViewModel';

const TAG = 'SCBSpecificScenePanel'
const log = LogHelper.getLogHelper(LogDomain.WINDOW, TAG);

@Component
export struct SCBSpecificScenePanel {
  @Link screenProperty: SCBScreenProperty;
  zorder: number = 0;
  private panelViewModel: SCBSpecificScenePanelViewModel = new SCBSpecificScenePanelViewModel(this.screenProperty);
  @State systemSceneList: SCBSpecificSceneSessionList = this.panelViewModel.specificSceneSessionList;

  // The floating window is hidden during recent shown.
  private hiddenFloatWindowList: SCBSpecificSceneSessionList = this.panelViewModel.hiddenFloatWindowList;
  private currSpecificSessionRect: SCBSessionRect = new SCBSessionRect();

  getSpecificContainerSessionList = (): SCBSpecificSceneSessionList => {
    return this.systemSceneList;
  }

  getZIndex(): number {
    return ZORDER_TO_DEFAULTZINDEX.get(this.zorder) || 0;
  }

  aboutToAppear(): void {
    log.showInfo('aboutToAppear');
    this.panelViewModel.init(this.zorder);
    SCBScreenSessionManager.getInstance().registerPropertyChangeScenePanelCallback((
      screenProperty: SCBScreenProperty,
      reason: SCBPropertyChangeReason) => {
      log.showDebug('SCBSpecificScenePanel screen callback is called');
      this.onScreenPropertyChange(screenProperty, reason);
    }, this.zorder, this.screenProperty.screenId);
    if (this.zorder === SpecificPanelZOrder.ABOVE_SCENE_PANEL) {
      SCBSceneSessionManager.getInstance().registerEnterRecentForFloatCallback(
        () => {
          this.hideLargeFloatWindowWhenEnterRecent();
        }
      );
      SCBSceneSessionManager.getInstance().registerExitRecentForFloatCallback(
        () => {
          this.showLargeFloatWindowWhenExitRecent();
        }
      );
    }
    this.currSpecificSessionRect = new SCBSessionRect(this.screenProperty.left, this.screenProperty.top,
      this.screenProperty.width, this.screenProperty.height);
  }

  private updateSpecificSessionWhenRotation(screenProperty: SCBScreenProperty,
    specificSession: SCBSpecificSession): void {
    if (specificSession.session?.type === sceneSessionManager.SessionType.TYPE_SYSTEM_FLOAT) {
      let screenRect = new SCBSessionRect(screenProperty.left, screenProperty.top,
        screenProperty.height, screenProperty.width);
      if (specificSession.currRect.equals(screenRect)) {
        specificSession.updateRect(new ScbNumber(screenProperty.left), new ScbNumber(screenProperty.top),
          new ScbNumber(screenProperty.width), new ScbNumber(screenProperty.height),
          sceneSessionManager.SessionSizeChangeReason.UNDEFINED);
      }
    }
  }

  private onScreenPropertyChange(screenProperty: SCBScreenProperty, reason: SCBPropertyChangeReason): void {
    log.showInfo('SCBSpecificScenePanel onScreenPropertyChange reason:' + reason +
      ' screenProperty:[' + screenProperty.left + ',' + screenProperty.top + ',' +
      screenProperty.width + ',' + screenProperty.height + ',' + screenProperty.rotation + ']');
    if (reason === SCBPropertyChangeReason.FOLD_SCREEN_ROTATION || reason === SCBPropertyChangeReason.PAGE_ROTATION) {
      for (let specificSession of this.systemSceneList) {
        if (!specificSession || specificSession.isActive === false) {
          continue;
        }
        this.updateSpecificSessionWhenRotation(screenProperty, specificSession);
      }
    }
    this.currSpecificSessionRect = new SCBSessionRect(screenProperty.left, screenProperty.top,
      screenProperty.width, screenProperty.height);
  }

  private recurveSubList(session: SCBSpecificSession, isVisibility: boolean): void {
    session.subSessionList.forEach(item => {
      this.recurveSubList(item, isVisibility);
      item.setVisibility(isVisibility);
      try {
        item.session.setTouchable(isVisibility);
      } catch (err) {
        log.showError(`setTouchable failed, reason: ${err?.message}`);
      }
    });
  }

  private hideLargeFloatWindowWhenEnterRecent(): void {
    this.systemSceneList.forEach((item: SCBSpecificSession) => {
      if (!(item instanceof SCBSpecificSession)) {
        log.showWarn('[SCBSystem] hide float window, item is null.');
        return;
      }
      if (item.session?.type === sceneSessionManager.SessionType.TYPE_FLOAT) {
        // 2 means half of screen
        if ((item.currRect.width.getPx() > (this.screenProperty.width / 2)) &&
          (item.currRect.height.getPx() > (this.screenProperty.height / 2))) {
          log.showInfo('[SCBSystem] hide float window with sessionId: ' + item.session?.persistentId.toString());
          this.recurveSubList(item, false);
          item.setVisibility(false);
          try {
            item.session.setTouchable(false);
          } catch (err) {
            log.showError('[SCBSystem] setTouchable failed, reason: ' + JSON.stringify(err));
          }
          this.hiddenFloatWindowList.push(item);
        }
      }
    });
  }

  private showLargeFloatWindowWhenExitRecent(): void {
    this.hiddenFloatWindowList.forEach((item: SCBSpecificSession) => {
      if (item instanceof SCBSpecificSession && item.session?.type === sceneSessionManager.SessionType.TYPE_FLOAT) {
        // 2 means half of screen
        log.showInfo('[SCBSystem] show hidden widow with sessionId: ' + item.session?.persistentId.toString());
        this.recurveSubList(item, true);
        item.setVisibility(true);
        try {
          item.session.setTouchable(true);
        } catch (err) {
          log.showError('[SCBSystem] setTouchable failed, reason: ' + JSON.stringify(err));
        }
      } else {
        log.showWarn('[SCBSystem] item is not available.');
      }
    });
    this.hiddenFloatWindowList.splice(0, this.hiddenFloatWindowList.length);
  }

  private getScenePanelTranslateOptions() : TranslateOptions {
    let option: TranslateOptions = {
      x: this.screenProperty?.getTranslateX() + 'px',
      y: this.screenProperty?.getTranslateY() + 'px'
    };
    log.showDebug('getScenePanelTranslateOptions: ' + JSON.stringify(option));
    return option;
  }

  private getScenePanelRotateOptions() : RotateOptions {
    let option: RotateOptions = {
      x: 0,
      y: 0,
      z: 1,
      angle: -this.screenProperty?.rotation,
      centerX: '50%',
      centerY: '50%'
    };
    log.showDebug('getScenePanelRotateOptions: ' + JSON.stringify(option));
    return option;
  }

  aboutToDisappear(): void {
    this.panelViewModel.release();
  }

  @Styles
  transformSceneStyles() {
    .id('SCBSpecificPanelTransformScene')
    .direction(Direction.Ltr)
    .zIndex(this.getZIndex())
    .position({ x: this.screenProperty.left + 'px', y: this.screenProperty.top + 'px' })
    .translate(this.getScenePanelTranslateOptions())
    .size({ width: this.screenProperty.width + 'px', height: this.screenProperty.height + 'px' })
    .rotate(this.getScenePanelRotateOptions())
    .hitTestBehavior(HitTestMode.None)
    .visibility(this.systemSceneList.length > 0 ? Visibility.Visible : Visibility.Hidden)
  }

  build() {
    WindowScene(SceneConstants.TRANSFORM_SCENE) { // transform scene, always full screen
      ForEach(this.systemSceneList, (item: SCBSpecificSession) => {
        SCBSpecificScene({
          specificSession: item,
          screenProperty: $screenProperty,
          rect: item.currRect,
          parentRect: item.currRect,
          subSessionList: item.subSessionList,
        })
      }, (item: SCBSpecificSession) => item.session?.persistentId.toString())
    }
    .transformSceneStyles();
  }
}
