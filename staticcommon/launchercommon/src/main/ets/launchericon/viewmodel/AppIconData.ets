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

import drawableDescriptor from '@ohos.arkui.drawableDescriptor';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { AppStatus } from '../../constants/CommonConstants';

const TAG = 'AppIconData';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.ICON, TAG);

/**
 * 重置长按震动标记的延时时间, 避免长按后抬手onGestureJudgeBegin时标记已经被重置
 */
const RESET_VIBRATED_FLAG_DELAY: number = 50;

export class AppIconData {
  // 分层图标显示
  @Track public isLayeredIcons?: boolean;
  @Track public foregroundImagePixel?: PixelMap | string | drawableDescriptor.DrawableDescriptor | Resource | undefined = '';
  @Track public backgroundImagePixel?: PixelMap | string | drawableDescriptor.DrawableDescriptor | Resource | undefined = '';
  @Track public shadowImagePixel?: PixelMap | null = null;
  @Track public isHighResolutionImage: boolean = false;

  @Track public image: string | PixelMap = '';
  // 组件Id
  @Track public iconId: string = '';
  // 文件夹堆叠态
  @Track public isSuperposeApp: boolean = false;
  @Track public isDragFlag: boolean = false;
  @Track public enableDrag: boolean = true;
  @Track public iconScale: number = 1.0;
  // 当前为了优化内存占用，当iconOpacity为0的时候，使用了isIconShow()函数的蒙层等相关节点会下树
  @Track public iconOpacity: number = 1.0;
  @Track public isLongPressHideMask: boolean = false;
  @Track public touchMaskVisible: boolean = false;
  // 图标组件的属性
  @Track public containerOpacity: number = 1.0;
  @Track public containerForeEffectRadius: number = -1;
  @Track public containerScale: number = 1.0;

  @Track public transX: number = 0;
  @Track public transY: number = 0;
  @Track public cloneBadgeVisible: boolean = true;
  // 是否显示自定义蒙层
  @Track public isShowMask: boolean = false;

  // 蒙层透明度
  @Track public maskOpacity: number = 0;

  // 自定义蒙层背景色
  @Track public maskBgColor: string = '#00000000';

  @Track public isLock: boolean = false;

  // 是否为动态图标
  @Track public isDynamicIcon: boolean = false;

  @Track public isOnlineTheme: boolean = false;

  @Track public itemOffset?: Position;

  @Track public appStatus: AppStatus = AppStatus.INSTALLED;
  // 用于Resize过程中图标X偏移
  @Track public offsetX: number = 0;
  // 用于Resize过程中图标Y偏移
  @Track public offsetY: number = 0;
  // 用于从卡片管理添加一键锁屏快捷图标到桌面控制名称显隐
  @Track public nameOpacity: number = 1;
  // 用于从卡片管理添加一键锁屏快捷图标到桌面控制多选框显隐
  @Track public checkboxOpacity: number = 1;
  // 用于Resize动效中空图标透明度判断
  public isEmpty: boolean = false;

  // 是否已经触发长按震动手势
  public isLongPressVibrated: boolean = false;

  public setItemOffset(position: Position): AppIconData {
    this.itemOffset = position;
    return this;
  }

  public setImage(image: string | PixelMap): AppIconData {
    this.image = image;
    return this;
  }

  public setIconId(iconId: string): AppIconData {
    this.iconId = iconId;
    return this;
  }

  public setIsSuperposeApp(isSuperposeApp: boolean): AppIconData {
    this.isSuperposeApp = isSuperposeApp;
    return this;
  }

  public setIsDragFlag(isDragFlag: boolean): AppIconData {
    this.isDragFlag = isDragFlag
    return this;
  }

  public setIsLongPressHideMask(isLongPressHideMask: boolean): AppIconData {
    this.isLongPressHideMask = isLongPressHideMask;
    return this;
  }

  public setTouchMaskVisible(touchMaskVisible: boolean): AppIconData {
    this.touchMaskVisible = touchMaskVisible;
    return this;
  }

  public setContainerOpacity(opacity: number): AppIconData {
    this.containerOpacity = opacity;
    return this;
  }

  public setTransX(transX: number): AppIconData {
    this.transX = transX;
    return this;
  }

  public setTransY(transY: number): AppIconData {
    this.transY = transY;
    return this;
  }

  public setCloneBadgeVisible(visible: boolean): AppIconData {
    this.cloneBadgeVisible = visible;
    return this;
  }

  public setIsShowMask(isShowMask: boolean): AppIconData {
    this.isShowMask = isShowMask;
    return this;
  }

  public setMaskOpacity(maskOpacity: number): AppIconData {
    this.maskOpacity = maskOpacity;
    return this;
  }

  public setMaskBgColor(maskBgColor: string): AppIconData {
    this.maskBgColor = maskBgColor;
    return this;
  }

  /**
   * 锁定图标相关属性值，锁定期间则无法通过set接口对图标属性值进行变更操作，避免属性动效期间因为属性变更导致动效异常。
   * 锁定方法必须和解除锁定方法配对使用，不要引起因为没有解除锁定导致set接口无效场景
   * 当前该方法为试点方法，仅对opt和scale属性生效，如后续有其他需要可以统一接入
   * @param isLock 是否锁定属性
   * @param msg 锁定、解锁的场景信息
   * @returns AppIconData
   */
  public setIsLock(isLock: boolean, msg: string): AppIconData {
    log.showInfo(`${isLock ? 'lock' : 'unlock'} appIcon attributes by ${msg}.`);
    this.isLock = isLock;
    return this;
  }

  public setIconScale(scale: number): AppIconData {
    if (this.isLock) {
      log.showInfo('The icon attribute has been locked.');
      return this;
    }
    log.showWarn(`setIconScale form ${this.iconScale} to ${scale}`);
    this.iconScale = scale;
    return this;
  }

  /**
   * 设置图标显隐的接口
   * 1、业务方调用时需要判断一下设置前后的不透明度值，如果一样不要调用，避免执行一些冗余代码
   * 2、图标组件内部不能自行判断，目的是做到问题可追溯
   *
   * @param opacity 不透明度
   * @param module 模块, 一般是类TAG
   * @param caller 调用方, 精确到函数
   * @param extra 额外参数打印信息
   * @returns AppIconData
   */
  public setIconOpacity(opacity: number, module: string, caller: string, extra?: string): AppIconData {
    if (this.isLock) {
      log.showWarn('The icon attribute has been locked.');
      return this;
    }

    log.showWarn('[%{public}s] set icon opacity from [%{public}d] to [%{public}d], caller: %{public}s, extra: %{public}s, iconId: %{public}s',
      module, this.iconOpacity, opacity, caller, extra, this.iconId);
    this.iconOpacity = opacity;
    // 设置图标透明度时，如果自定义蒙层显示，需要同步设置蒙层透明度
    if (this.isShowMask) {
      this.setMaskOpacity(opacity);
    }
    return this;
  }

  public getIconOpacity(): number {
    return this.iconOpacity;
  }

  public setAppStatus(appStatus: number): AppIconData {
    this.appStatus = appStatus;
    return this;
  }


  public setLongPressVibrated(isLongPressVibrated: boolean): AppIconData {
    this.isLongPressVibrated = isLongPressVibrated;
    return this;
  }

  public resetLongPressVibrated(): void {
    setTimeout(() => {
      this.isLongPressVibrated = false;
    }, RESET_VIBRATED_FLAG_DELAY);
  }
}