/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
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

import { Log } from '@ohos/basicutils';
import { SCBConstants } from '@ohos/commonconstants';
import { ViewController } from '@ohos/frameworkwrapper';
import { FocusChangeReason, SCBSceneSessionManager } from '@ohos/windowscene';

@Observed
export class CloneWallpaperModel {
  public winOpacity: number = 1;
  public isBlur: boolean = false;
  public bkBlur: number = 0;
  public bcColor: string = SCBConstants.DEFAULT_SCENE_BG_COLOR;
}

const TAG = 'CloneWallpaperMgr';

export class CloneWallpaperMgr {
  private static instances = new Map<number, CloneWallpaperMgr>();
  private wallpaperModel: CloneWallpaperModel = new CloneWallpaperModel();
  private viewController: ViewController | undefined = undefined;
  private persistentId: number = -1;
  private srcWindowId: number = -1;
  private isCloned: boolean = false;
  private showCmdId: number = 0;

  private constructor() {
  }

  public static getInstance(screenId: number): CloneWallpaperMgr {
    let mgr = CloneWallpaperMgr.instances.get(screenId);
    if (mgr === undefined) {
      mgr = new CloneWallpaperMgr();
      CloneWallpaperMgr.instances.set(screenId, mgr);
    }
    return mgr;
  }

  public static release(screenId: number) {
    Log.showInfo(TAG, `instance list:${CloneWallpaperMgr.instances.size}`);
    CloneWallpaperMgr.instances.delete(screenId);
  }

  /**
   * 初始化
   * @param controller
   * @param persistentId
   */
  public initViewController(controller: ViewController, persistentId: number): void {
    this.viewController = controller;
    this.persistentId = persistentId;
  }

  /**
   * 设置复制的目标窗口
   * @param srcWindowId 目标窗口id
   */
  public initSrcWindow(srcWindowId: number): void {
    this.srcWindowId = srcWindowId;
  }

  public getCloneWallpaperModel(): CloneWallpaperModel {
    return this.wallpaperModel;
  }

  public requestFocus(): void {
    SCBSceneSessionManager.getInstance()
      .requestFocus(this.viewController?.getPersistentId(), false, FocusChangeReason.RECENT);
  }

  /**
   * 更新克隆壁纸图层Z序
   * @param zIndex z序
   */
  public updateZIndex(zIndex: number): void {
    Log.showInfo(TAG, `updateZIndex:${zIndex}`);
    if (this.viewController?.getZIndex() !== zIndex) {
      this.viewController?.setZIndex(zIndex);
    }
  }

  private updateView(isBlur: boolean = true): void {
    this.wallpaperModel.isBlur = isBlur;
    if (isBlur) {
      this.wallpaperModel.winOpacity = 1;
      this.wallpaperModel.bkBlur = 1.0;
      this.wallpaperModel.bcColor = SCBConstants.APP_CENTER_BG_BLUR_COLOR;
    } else {
      this.wallpaperModel.winOpacity = 1;
      this.wallpaperModel.bkBlur = 0;
      this.wallpaperModel.bcColor = SCBConstants.DEFAULT_SCENE_BG_COLOR;
    }
  }

  /**
   * 克隆壁纸显示,可在动效回调函数中使用
   * @param isBlur 是否带前景模糊. 应用中心&多任务中心带前景模糊. 解锁进桌面不带前景模糊
   * @returns 当前的指令id, 用于防打断: 在动效回调函数中执行hide时,如果id不匹配,这hide指令失效
   */
  public show(isBlur: boolean = true): number {
    ++this.showCmdId;
    Log.showInfo(TAG, `show persistentId:${this.persistentId} cmdId:${this.showCmdId}`);
    // hpr应用中心&多任务中心不使用克隆窗口
    if (!this.isCloned) {
      SCBSceneSessionManager.getInstance().cloneWindow(this.srcWindowId, this.persistentId);
      this.isCloned = true;
    }
    if (!this.viewController?.isShowing()) {
      this.viewController?.show();
    }
    this.updateView(isBlur);
    return this.showCmdId;
  }

  /**
   * 窗口下树,资源释放
   */
  public hideAll(): void {
    Log.showInfo(TAG, `hideAll`);
    if (this.viewController?.isShowing()) {
      this.hideFinish();
      this.hide();
    }
  }

  /**
   * 克隆壁纸渐变消失, 动效回调函数中调用
   */
  public hide(cmdId?: number): void {
    Log.showInfo(TAG, `hide ${this.showCmdId} ${cmdId}`);
    if (cmdId !== undefined && this.showCmdId !== cmdId) {
      Log.showInfo(TAG, `cmd ${cmdId} is interrupt`);
      return;
    }
    this.wallpaperModel.winOpacity = 0;
    this.wallpaperModel.bkBlur = 0;
    this.wallpaperModel.bcColor = SCBConstants.DEFAULT_SCENE_BG_COLOR;
  }

  /**
   * 动效结束后,整个窗口下树,释放资源
   */
  public hideFinish(cmdId?: number): void {
    Log.showInfo(TAG, `hide finish ${this.showCmdId} ${cmdId}`);
    if (cmdId !== undefined && this.showCmdId !== cmdId) {
      Log.showInfo(TAG, `cmd ${cmdId} is interrupt`);
      return;
    }
    if (this.viewController?.isShowing()) {
      this.viewController?.hide();
    }
    if (this.isCloned) {
      SCBSceneSessionManager.getInstance().cloneWindow(-1, this.persistentId);
      this.isCloned = false;
    }
  }
}