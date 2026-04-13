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

import { LogDomain, LogHelper } from '@ohos/basicutils';
import { GlassSysSceneSession } from '../system/GlassSysSceneSession';
import { Rect } from '../common/GlassSceneManager'

const TAG: string = 'GlassSystemSceneManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.VISION_GLASS, TAG);

export enum GlassSystemSceneType {
  UNDEFINED_TYPE,
  SCENE_PANEL,
  GLASS_BANNER,
  GLASS_STATUS_BAR,
  GLASS_CONTROL,
  GLASS_VOLUME,
  GLASS_NOTIFICATION_CENTER,
  GLASS_SCREENSHOT_PREVIEW,
  GLASS_TOAST,
  GLASS_STATUS_BAR_HOVER,
  GLASS_CONTROL_CENTER_SUBPAGE,
}

/*
 * 管理桌面系统控件窗口的显示隐藏
 * */
export class GlassSystemSceneManager {
  private static instance: GlassSystemSceneManager | undefined = undefined;
  private systemViewMap: Map<GlassSystemSceneType, GlassSysSceneSession> = new Map();
  /*
   * 与桌面互斥的窗口type记录，用于判断当前是否处于桌面以及桌面互斥窗口层级退出
   * */
  private desktopMutexWindows: Set<GlassSystemSceneType> = new Set([
    GlassSystemSceneType.GLASS_CONTROL,
    GlassSystemSceneType.GLASS_NOTIFICATION_CENTER,
    GlassSystemSceneType.GLASS_CONTROL_CENTER_SUBPAGE
  ]);

  /*
   * 获取当前类单实例
   * */
  public static getInstance(): GlassSystemSceneManager {
    if (!GlassSystemSceneManager.instance) {
      log.showInfo(`getInstance new instance`);
      GlassSystemSceneManager.instance = new GlassSystemSceneManager();
    }
    return GlassSystemSceneManager.instance;
  }

  /*
   * 销毁当前类实例，清理数据集合
   * */
  public static destroyInstance(): void {
    GlassSystemSceneManager.instance?.release();
    GlassSystemSceneManager.instance = undefined;
  }

  /*
   * 清理系统控件session实例
   * */
  private release(): void {
    log.showInfo(`release`)
    this.systemViewMap.forEach((sysSceneSession: GlassSysSceneSession) => {
      sysSceneSession.requestSceneSessionDestruction();
    });
    this.systemViewMap.clear();
  }

  /**
   * 注册系统控件会话
   *
   * @param sceneType 场景类型
   * @param sysSession 系统会话
   */
  public registerSystemSceneSession(sceneType: number, sysSession: GlassSysSceneSession): void {
    log.showInfo(`registerSystemSceneSession sceneType is ${sceneType}`);
    this.systemViewMap.set(sceneType, sysSession);
  }

  /*
   * 注销系统控件会话
   *
   * @param sceneType 场景类型
   * */
  public unRegisterSystemSceneSession(sceneType: number): void {
    log.showInfo(`unRegisterSystemSceneSession sceneType is ${sceneType}`);
    this.systemViewMap.delete(sceneType);
  }

  /*
   * 展示指定系统控件
   *
   * @param sceneType 场景类型
   * */
  public showSystemView(type: GlassSystemSceneType): void {
    let curView: GlassSysSceneSession | undefined = this.systemViewMap.get(type);
    if (curView === undefined) {
      log.showError(`showSystemView fail,curView type ${type} is not exist`);
      return;
    }
    log.showInfo(`showSystemView success,curView type ${type}`);
    curView.setVisibility(true);
  }

  /*
   * 隐藏指定系统控件
   *
   * @param sceneType 场景类型
   * */
  public hideSystemView(type: GlassSystemSceneType): void {
    let curView: GlassSysSceneSession | undefined = this.systemViewMap.get(type);
    if (curView === undefined) {
      log.showError(`hideSystemView fail,curView type ${type} is not exist`);
      return;
    }
    log.showInfo(`hideSystemView success,curView type ${type}`);
    curView.setVisibility(false);
  }

  /*
   * 判断指定系统控件是否展示
   *
   * @param sceneType 场景类型
   * @return boolean 是否展示的状态
   * */
  public isSystemViewShow(type: GlassSystemSceneType): boolean {
    let curView: GlassSysSceneSession | undefined = this.systemViewMap.get(type);
    if (curView === undefined) {
      log.showError(`isSystemViewShow fail,curView type ${type} is not exist`);
      return false;
    }
    log.showInfo(`isSystemViewShow ${curView.isShow()},curView type ${type}`);
    return curView.isShow();
  }

  /*
   * 更新指定系统窗口rect数值
   *
   * @param sceneType 场景类型
   * @param rect 窗口宽高 坐标
   * */
  public updateWindowRect(type: GlassSystemSceneType, rect: Rect): void {
    let curView: GlassSysSceneSession | undefined = this.systemViewMap.get(type);
    if (curView === undefined) {
      log.showError(`updateWindowRect fail,curView type ${type} is not exist`);
      return;
    }
    log.showInfo(`updateWindowRect success,curView type ${type},rect is ${JSON.stringify(rect)}`);
    if (rect?.left) {
      curView.updateRect({ left: rect.left });
    }
    if (rect?.top) {
      curView.updateRect({ top: rect.top });
    }
    if (rect?.width) {
      curView.updateRect({ width: rect.width });
    }
    if (rect?.height) {
      curView.updateRect({ height: rect.height });
    }
  }

  /*
   * 设置指定系统控件rect动画
   *
   * @param sceneType 场景类型
   * @param rect 窗口宽高 坐标
   * @param animateParam 动画参数
   * @param onFinishCallback 动画执行结束的回调
   * */
  public setSystemViewAnimate(
    type: GlassSystemSceneType,
    animateParam: AnimateParam,
    rect: Rect,
    onFinishCallback?: (() => void) | undefined): void {
    let curView: GlassSysSceneSession | undefined = this.systemViewMap.get(type);
    if (curView === undefined) {
      log.showError(`setSystemViewAnimate fail,curView type ${type} is not exist`);
      return;
    }
    log.showInfo(`setSystemViewAnimate success`);
    curView.setRectAnimate(animateParam, rect, onFinishCallback);
  }

  /*
   * 设置系统控件窗口透明度
   *
   * @param sceneType 场景类型
   * @param opacity 透明度
   * */
  public setSystemViewOpacity(type: GlassSystemSceneType, opacity: number): void {
    let curView: GlassSysSceneSession | undefined = this.systemViewMap.get(type);
    if (curView === undefined) {
      log.showError(`setSystemViewOpacity fail,curView type ${type} is not exist`);
      return;
    }
    log.showInfo(`setSystemViewOpacity success,opacity is ${opacity}`);
    curView.setOpacity(opacity);
  }

  /*
   * 检查当前是否存在窗口与桌面互斥,有则退出并返回结果
   *
   * @return hasWindowMutexWithDesktop boolean
   * */
  public hasWindowMutexWithDesktop(isNeedClose: boolean): boolean {
    let hasWindowMutexWithDesktop: boolean = false;
    this.systemViewMap.forEach((window: GlassSysSceneSession, key: GlassSystemSceneType) => {
      if (hasWindowMutexWithDesktop) { //存在第一个窗口被退出则循环不再执行
        log.showInfo(`hasWindowMutexWithDesktop already true,cancel operation.`);
        return;
      }
      if (window.isShow() && this.desktopMutexWindows.has(key)) {
        if (isNeedClose) {
          this.systemViewMap.get(key)?.setVisibility(false);
          if (key === GlassSystemSceneType.GLASS_CONTROL_CENTER_SUBPAGE) {
            this.showSystemView(GlassSystemSceneType.GLASS_CONTROL);
          }
        }
        hasWindowMutexWithDesktop = true;
        log.showInfo(`hasWindowMutexWithDesktop,true hide window type ${key}`);
      }
    })
    return hasWindowMutexWithDesktop;
  }

  /*
   * 退出当前所有系统窗口
   * */
  public closeAllSystemWindow(): void {
    log.showInfo(`closeAllSystemWindow`);
    this.systemViewMap.forEach((window: GlassSysSceneSession, key: GlassSystemSceneType) => {
      if (window.isShow() && this.desktopMutexWindows.has(key)) {
        this.systemViewMap.get(key)?.setVisibility(false);
      }
    })
  }
}