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
import { BaseViewController } from '@ohos/frameworkcommon';
import lazy { ViewArea, ViewManagerPolicy, viewMgrPolicy, ViewType } from '@ohos/frameworkwrapper';
import { threadCall, ThreadCallType } from '../messageChannel/ThreadCall';
import { ViewManagerAdapter } from './ViewManagerAdapter';
import { StatusBarController } from '../statusbar/controller/StatusBarController'
import { SystemUICcmConfig } from '../utils/SystemUICcmConfig';

const TAG = 'StatusBarViewControllerAdapter';
const log = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

export class StatusBarViewControllerAdapter {
  private static get = SingletonHelper.createFactory(() => new StatusBarViewControllerAdapter());
  public static get instance(): StatusBarViewControllerAdapter {
    return this.get();
  }

  private controller: BaseViewController = new StatusBarController();

  private area: ViewArea = {
    top: 0,
    left: 0,
    width: 0,
    height: 0
  };

  constructor() {
  }

  @threadCall()
  updateId(persistentId: number): void | Promise<void> {
    return this.controller.updateId(persistentId);
  }

  @threadCall()
  register(): void | Promise<void> {
    log.showInfo('Register statusbar controller');
    viewMgrPolicy.registerViewController(ViewType.STATUS_BAR, this.controller);
  }

  @threadCall()
  unregister(): void | Promise<void> {
    ViewManagerAdapter.unregisterViewController(ViewType.STATUS_BAR);
  }

  @threadCall()
  public updateRect(rect: ViewArea): void | Promise<void> {
    this.controller.updateRect(rect);
  }

  @threadCall()
  public updateArea(area: ViewArea): void | Promise<void> {
    this.controller.updateArea(area);
  }

  public updateAreaWithCache(area: ViewArea): void {
    this.updateArea(area);
    if (this.area && this.area.left === area.left && this.area.top === area.top &&
      this.area.width === area.width && this.area.height === area.height) {
      return;
    }
    this.area = {
      top: area.top,
      left: area.left,
      width: area.width,
      height: area.height
    };
  }

  public getStatusBarArea(): ViewArea {
    if (SystemUICcmConfig.instance.isEnabledWorker) {
      return {
        top: this.area.top,
        left: this.area.left,
        width: this.area.width,
        height: this.area.height
      };
    }

    return ViewManagerPolicy.getArea(ViewType.STATUS_BAR);
  }

  @threadCall()
  public show(): void {
    log.showInfo('show statusbar');
    this.controller.show();
  }

  @threadCall()
  public isShowing(): boolean | Promise<boolean> {
    return this.controller.isShowing();
  }

  @threadCall()
  public hide(): void | Promise<void> {
    this.controller.hide();
  }

  @threadCall()
  public setResponseRegion(responseRegions: Array<Rectangle>) {
    this.controller.setResponseRegion(responseRegions);
  }
}