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
import { LogDomain, LogHelper, SingletonHelper } from '@ohos/basicutils';
import { BaseViewController } from '@ohos/frameworkcommon';
import { ViewArea, viewMgrPolicy, ViewType } from '@ohos/frameworkwrapper';
import { threadCall, ThreadCallType } from '../messageChannel/ThreadCall';
import { ViewManagerAdapter } from './ViewManagerAdapter';

const TAG = 'BannerViewControllerAdapter';
const log = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

export class BannerViewControllerAdapter {
  private static get = SingletonHelper.createFactory(() => new BannerViewControllerAdapter());
  public static get instance(): BannerViewControllerAdapter {
    return this.get();
  }

  private controller: BaseViewController = new BaseViewController(ViewType.NOTIFICATION_BANNER);

  @threadCall()
  public show(isFocusableOnShow?: boolean): void {
    return this.controller.show(isFocusableOnShow);
  }

  @threadCall()
  public hide(): void {
    return this.controller.hide();
  }

  @threadCall()
  updateId(persistentId: number): void | Promise<void> {
    return this.controller.updateId(persistentId);
  }

  @threadCall()
  updateArea(area: ViewArea): void {
    return this.controller.updateArea(area);
  }

  @threadCall()
  updateRect(rect: ViewArea): void {
    return this.controller.updateRect(rect);
  }

  @threadCall()
  getId(): number {
    return this.controller.getId();
  }

  @threadCall()
  register(): void {
    log.showInfo('Register banner controller');
    viewMgrPolicy.registerViewController(ViewType.NOTIFICATION_BANNER, this.controller);
  }

  @threadCall()
  unregister(): void {
    ViewManagerAdapter.unregisterViewController(ViewType.NOTIFICATION_BANNER);
  }

  @threadCall()
  setResponseRegion(responseRegion: Array<Rectangle>): void {
    this.controller?.setResponseRegion(responseRegion);
  }
}