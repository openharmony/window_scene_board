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

import { RTLUtil } from '@ohos/componenthelper';
import { ResizeConfig, ResizeHotArea, StyleConstants } from '../../../../TsIndex';
import { IContractedFolderObserver } from '../../contractedfolder/viewmodel/layout/IContractedFolderObserver';
import { FolderAnimationPlaybackManager } from '../dfx/playback/FolderAnimationPlaybackManager';
import { ATTRIBUTE_TYPE, OBSERVER_SWITCH, OBSERVER_TYPE } from '../FolderCommonConstant';
import { BackgroundObserverImpl } from './BackgroundObserverImpl';
import { IObserver } from './IObserver';
import { FolderIconObserverImpl } from './FolderIconObserverImpl';
import { LogDomain, Logger } from '@ohos/basicutils';

const TAG = 'BaseObserverManager';
const log: Logger = Logger.getLogHelper(LogDomain.HOME);

/**
 * 文件夹布局observer管理
 */
export class BaseObserverManager {
  private folderId: string = '';
  private layoutOsr: IContractedFolderObserver;
  private observerUpdatorMap: Map<number, ComponentUpdator<IObserver>> = new Map();

  public constructor(folderId: string, osr: IContractedFolderObserver) {
    this.folderId = folderId;
    this.layoutOsr = osr;
  }

  /**
   * 获取状态变量更新的子组件更新器
   *
   * @param msg 用于DFX日志
   * @param osrType 子组件observer类型
   * @returns
   */
  public getObserverUpdator(msg: string, osrType: number): ComponentUpdator<IObserver> {
    if (this.observerUpdatorMap.has(osrType)) {
      log.showInfo(TAG, `getObserverUpdator ${msg}, ${osrType}`);
      return this.observerUpdatorMap.get(osrType) as ComponentUpdator<IObserver>;
    }
    let childOsr: IObserver = this.layoutOsr.getChildOsr(msg, osrType);
    let osrUpdator: ComponentUpdator<IObserver>;
    if (osrType === OBSERVER_TYPE.FOLDER_BG) {
      osrUpdator = new BackgroundUpdator(this.folderId, childOsr as BackgroundObserverImpl, msg);
    } else if (osrType === OBSERVER_TYPE.ICON_DATA || osrType === OBSERVER_TYPE.SND_ICON_DATA) {
      osrUpdator = new FolderIconUpdator(this.folderId, childOsr as FolderIconObserverImpl, msg);
    } else {
      osrUpdator = new ComponentUpdator(this.folderId, childOsr, msg);
    }
    this.observerUpdatorMap.set(osrType, osrUpdator);
    return osrUpdator;
  }

  /**
   * 清空子组件更新器Map
   */
  public clearObserverUpdatorMap(): void {
    this.observerUpdatorMap.clear();
  }

  /**
   * 切换文件夹开关状态变量值
   *
   * @param msg 用于DFX日志
   * @param switchType 状态变量类型
   * @param status 状态
   * @returns 更新器
   */
  public switchStatus(msg: string, switchType: number, status: boolean): BaseObserverManager {
    this.layoutOsr.setStatus(msg, switchType, status);
    return this;
  }

  /**
   * 获取文件夹开关状态变量的状态
   *
   * @param switchType 状态变量类型
   * @returns 状态值
   */
  public getStatus(switchType: number): boolean {
    return this.layoutOsr.getStatus(switchType);
  }

  /**
   * 文件夹名字透明度更新
   *
   * @param folderId 文件夹id
   * @param opacity 透明度
   * @returns
   */
  public setFolderNameOpacity(msg: string, opacity: number): void {
    this.layoutOsr.setFolderTitleOpacity(msg, opacity);
  }

  /**
   * 获取下载的透明度
   *
   * @returns 透明度
   */
  public getDownloadMaskOpacity(): number {
    return this.layoutOsr.getDownloadOpacity();
  }

  /**
   * 设置下载的透明度
   *
   * @param msg DFX的日志打印
   * @param opacity 透明度
   */
  public downloadMaskOpacity(msg: string, opacity: number): void {
    this.layoutOsr.setDownloadOpacity(msg, opacity);
  }

  /**
   * 获取是否隐藏下载背板
   */
  public getIsHideMask(): boolean {
    return this.getStatus(OBSERVER_SWITCH.DOWNLOAD_MASK);
  }

  /**
   * 获取文件夹是否显示最后一页
   */
  public getIsShowEndPage(): boolean {
    return this.getStatus(OBSERVER_SWITCH.END_PAGE_SHOW);
  }

  /**
   * 获取文件夹菜单是否显示
   */
  public getIsMenuShow(): boolean {
    return this.getStatus(OBSERVER_SWITCH.MENU_SHOW);
  }

  /**
   * 设置占位图标可见
   *
   * @param msg 用于DFX日志
   */
  public showPlaceHolder(msg: string): void {
    this.getObserverUpdator(msg, OBSERVER_TYPE.PH_ICON_FST).opacity(1.0).offsetX(0.0).offsetY(0.0);
    this.getObserverUpdator(msg, OBSERVER_TYPE.PH_ICON_SND).opacity(1.0).offsetX(0.0).offsetY(0.0);
  }

  /**
   * 隐藏占位图标
   *
   * @param msg 用于DFX日志
   */
  public hidePlaceHolder(msg: string): void {
    let rate: number = RTLUtil.getRTLRate();
    let pos: number = StyleConstants.FOLDER_PLACEHOLDER_ANIMATE_POSITION;
    this.getObserverUpdator(msg, OBSERVER_TYPE.PH_ICON_FST).opacity(0.0).offsetX(pos * rate).offsetY(pos);
    this.getObserverUpdator(msg, OBSERVER_TYPE.PH_ICON_SND).opacity(0.0).offsetX(pos / 2 * rate).offsetY(pos / 2);
  }
}

/**
 * 组件状态变量更新类
 */
export class ComponentUpdator<T extends IObserver> {
  protected key: string = 'FolderUpdator_';
  protected osr: T;
  protected msg: string;
  protected cycle: FolderAnimationPlaybackManager = FolderAnimationPlaybackManager.getInstance();

  public constructor(folderId: string, osr: T, msg: string) {
    this.key = this.key + folderId;
    this.osr = osr;
    this.msg = msg;
  }

  /**
   * 更新DFX日志
   *
   * @param msg DFX日志
   * @returns
   */
  public setMessage(msg: string): ComponentUpdator<T> {
    this.msg = msg;
    return this;
  }

  /**
   * 设置属性值
   *
   * @param type 属性类型
   * @param value 更新值
   */
  public setAttribute(type: ATTRIBUTE_TYPE, value: number): ComponentUpdator<T> {
    let fromValue: number = this.getAttribute(type);
    this.cycle.record(this.key, this.msg + `_${type}`, fromValue, value, 0, 0, -1);
    this.osr.setAttribute(type, value);
    return this;
  }

  /**
   * 获取属性值
   *
   * @param type 属性类型
   * @returns 属性值
   */
  public getAttribute(type: ATTRIBUTE_TYPE): number {
    return this.osr.getAttribute(type);
  }

  /**
   * 透明度更新
   *
   * @param value 更新值
   * @returns
   */
  public opacity(value: number): ComponentUpdator<T> {
    this.cycle.record(this.key, this.msg + 'opacity', this.osr.opacity, value, 0, 0, -1);
    this.osr.setAttribute(ATTRIBUTE_TYPE.OPACITY, value);
    return this;
  }

  /**
   * 圆角更新
   *
   * @param value 更新值
   * @returns
   */
  public borderRadius(value: number): ComponentUpdator<T> {
    return this.setAttribute(ATTRIBUTE_TYPE.BORDER_RADIUS, value);
  }

  /**
   * 缩放更新
   *
   * @param value 更新值
   * @returns
   */
  public scale(value: number): ComponentUpdator<T> {
    this.cycle.record(this.key, this.msg + 'scale', this.osr.scale, value, 0, 0, -1);
    this.osr.setAttribute(ATTRIBUTE_TYPE.SCALE, value);
    return this;
  }

  /**
   * x方向缩放更新
   *
   * @param value 更新值
   * @returns
   */
  public scaleX(value: number): ComponentUpdator<T> {
    this.cycle.record(this.key, this.msg + 'scaleX', this.osr.scaleX, value, 0, 0, -1);
    this.osr.setAttribute(ATTRIBUTE_TYPE.SCALE_X, value);
    return this;
  }

  /**
   * y方向缩放更新
   *
   * @param value 更新值
   * @returns
   */
  public scaleY(value: number): ComponentUpdator<T> {
    this.cycle.record(this.key, this.msg + 'scaleY', this.osr.scaleY, value, 0, 0, -1);
    this.osr.setAttribute(ATTRIBUTE_TYPE.SCALE_Y, value);
    return this;
  }

  /**
   * x方向位移更新
   *
   * @param value 更新值
   * @returns
   */
  public transX(value: number): ComponentUpdator<T> {
    this.cycle.record(this.key, this.msg + 'transX', this.osr.transX, value, 0, 0, -1);
    this.osr.setAttribute(ATTRIBUTE_TYPE.TRANS_X, value);
    return this;
  }

  /**
   * y方向位移更新
   *
   * @param value 更新值
   * @returns
   */
  public transY(value: number): ComponentUpdator<T> {
    this.cycle.record(this.key, this.msg + 'transY', this.osr.transY, value, 0, 0, -1);
    this.osr.setAttribute(ATTRIBUTE_TYPE.TRANS_Y, value);
    return this;
  }

  /**
   * x方向偏移量更新
   *
   * @param value 更新值
   * @returns
   */
  public offsetX(value: number): ComponentUpdator<T> {
    this.cycle.record(this.key, this.msg + 'offsetX', this.osr.offsetX, value, 0, 0, -1);
    this.osr.offsetX = value;
    return this;
  }

  /**
   * y方向偏移量更新
   *
   * @param value 更新值
   * @returns
   */
  public offsetY(value: number): ComponentUpdator<T> {
    this.cycle.record(this.key, this.msg + 'offsetY', this.osr.offsetY, value, 0, 0, -1);
    this.osr.offsetY = value;
    return this;
  }

  /**
   * 返回组件observer的透明度
   *
   * @returns 透明度
   */
  public getOpacity(): number {
    return this.osr.opacity;
  }

  /**
   * 获取组件的缩放值
   *
   * @returns 缩放值
   */
  public getScale(): number {
    return this.osr.scale;
  }
}

export class BackgroundUpdator extends ComponentUpdator<BackgroundObserverImpl> {
  constructor(folderId: string, osr: BackgroundObserverImpl, msg: string) {
    super(folderId, osr, msg);
  }

  /**
   * 更新进入编辑模式
   * @param isEditMode
   */
  public updateByEditMode(isEditMode: boolean): void {
    this.osr.updateByEditMode(isEditMode);
  }
}

/**
 * 动效图标节点的updator
 */
export class FolderIconUpdator extends ComponentUpdator<FolderIconObserverImpl> {
  constructor(folderId: string, osr: FolderIconObserverImpl, msg: string) {
    super(folderId, osr, msg);
  }

  public finish(): void {
    this.osr?.finish();
  }
}