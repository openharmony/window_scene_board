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

import { LogDomain, LogHelper, SingletonHelper } from '@ohos/basicutils';
import { EventManager, EvtBus, ViewCallback, ViewManagerPolicy, ViewType } from '@ohos/frameworkwrapper';
import { SceneSessionAdapter } from '../../adapter/SceneSessionAdapter';
import { inspector } from '@kit.ArkUI';
import image from '@ohos.multimedia.image';
import { StaticBlurViewData } from './StaticBlurViewData';
import { StaticBlurEvent } from '@ohos/systemuiutils/src/main/ets/sysdialog/CommonEvent';
import { ViewManagerAdapter, ViewMgrPolicyViewCallback } from '../../adapter/ViewManagerAdapter';

const TAG = 'StaticBlurController';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

export const SNAPSHOT_COMPONENT_ID: string = 'dropdown_panel_cover_image'

/**
 * 双中心静态模糊控制器
 * 用于实施下拉静态模糊方案
 */
export class StaticBlurController {
  private persistentId: number = 0;
  private listener: inspector.ComponentObserver = inspector.createComponentObserver(SNAPSHOT_COMPONENT_ID)
  private staticBlurViewData?: StaticBlurViewData;
  private eventMgr: EventManager = EvtBus.createEventManager();
  private isExecuteDrawCompleted: boolean = true;

  constructor() {
    this.registerSnapShotObserver();
    this.registerStaticBlurEvent();
    ViewManagerAdapter.registerViewCallback(this.dropDownCallback, `${TAG}_registerViewCallback`);
    this.isExecuteDrawCompleted = true;
  }

  private dropDownCallback: ViewMgrPolicyViewCallback = {
    viewType: ViewType.DROPDOWN,
    onHide: (): void => {
      this.clearSnapShot();
    }
  }

  public unRegisterAll() {
    this.eventMgr.offAll();
    this.listener.off('draw', ():void=>{});
    ViewManagerAdapter.unRegisterViewCallback(this.dropDownCallback, `${TAG}_registerViewCallback`);
  }

  private registerStaticBlurEvent() {
    this.eventMgr.on(StaticBlurEvent, (event: StaticBlurEvent) => {
      if (event.command === 0) {
        this.clearSnapShot();
      }
    });
  }

  init(staticBlurViewData: StaticBlurViewData, persistentId: number) {
    this.persistentId = persistentId;
    this.staticBlurViewData = staticBlurViewData;
  }

  private registerSnapShotObserver() {
    // 收到截图绘制完成之后的回调再对下面的窗口进行遮挡剔除，否则会出现黑屏
    let onDrawComplete: () => void = (): void => {
      log.showInfo('draw finish');
      if (this.isExecuteDrawCompleted) {
        SceneSessionAdapter.setSystemSceneOcclusionAlpha(this.persistentId, 1);
        log.showWarn('setSystemSceneOcclusion success, and snapshot is ' +
          ((this.staticBlurViewData?.getSnapShot() == null) ? 'null, black screen phenomenon may occur.' :
          'not null, ' + 'PixelBytes: ' + this.staticBlurViewData?.getSnapShot()?.getPixelBytesNumber()));
      }
    };
    this.listener.on('draw', onDrawComplete);
  }

  public showSnapShot() {
    this.staticBlurViewData?.setShouldShowSnapShot(true);
  }

  public getSnapShot(): image.PixelMap | undefined {
    return this.staticBlurViewData?.getSnapShot();
  }

  public shouldShowSnapShot(): boolean {
    return this.staticBlurViewData?.getShouldShowSnapShot() ?? false;
  }

  /**
   * 隐藏截图，必须通过该接口隐藏截图，否则可能出现黑屏
   */
  public hideSnapShot() {
    log.showInfo('hide snap shot');
    SceneSessionAdapter.setSystemSceneOcclusionAlpha(this.persistentId, 0);
    this.staticBlurViewData?.setShouldShowSnapShot(false);
  }

  /**
   * 隐藏并清除截图，必须通过该接口隐藏截图，否则可能出现黑屏
   */
  public clearSnapShot() {
    log.showInfo('clear snap shot');
    this.hideSnapShot();
    this.staticBlurViewData?.releaseSnapShot();
    this.isExecuteDrawCompleted = false;
  }

  public saveSnapShot(image: image.PixelMap) {
    this.staticBlurViewData?.setSnapShot(image);
    this.isExecuteDrawCompleted = true;
  }

  public static getInstance(): StaticBlurController {
    let staticBlurController: StaticBlurController = SingletonHelper.getInstance(StaticBlurController, TAG);
    return staticBlurController;
  }
}