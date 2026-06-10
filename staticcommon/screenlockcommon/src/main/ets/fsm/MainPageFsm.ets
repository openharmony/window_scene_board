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

import { LogDomain, LogHelper } from '@ohos/basicutils';
import { AbstractEvent, AbstractFsm, AbstractState, AbstractStateFactory } from './ScreenLockFsm';
import type { MatchRule } from './ScreenLockFsm';
import { CoreEvent, CoreEventType, CoreStateType, CoreStateTypeUtils } from './ScreenLockCoreFsm';

const TAG = 'MainPageFsm';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);

const SCREEN_OFF_PAGE = 0x1000; // 熄屏页
const MAIN_PAGE = 0x2000; // 主页
const BOUNCER_PAGE = 0x4000; // 密码页
const UNLOCK_PAGE = 0x8000; // 非锁屏页

const NORMAL_SHOW = 0x100; // 常态显示态
const EDIT = 0x200; // 编辑态
const FAKE_AOD = 0x400; // 假AOD态
const INACTIVE = 0x800; // 去激活态

const EDIT_EXTENSION = 0x20; // 编辑外部接入态

/**
 * 定义：主页状态机-状态类型
 */
export enum MpStateType {
  /**
   * 初始态
   */
  INIT_STATE = 0,

  /**
   * 熄屏态
   */
  SCREEN_OFF_STATE = SCREEN_OFF_PAGE,

  /**
   * 常态锁屏态
   */
  NORMAL_LOCK_STATE = MAIN_PAGE | NORMAL_SHOW | 0x1,

  /**
   * 去激活态
   */
  INACTIVE_STATE = MAIN_PAGE | INACTIVE,

  /**
   * 常态解锁态
   */
  NORMAL_UNLOCK_STATE = MAIN_PAGE | NORMAL_SHOW | 0x2,

  /**
   * 常态AOD态
   */
  NORMAL_FAKE_AOD_STATE = MAIN_PAGE | FAKE_AOD,

  /**
   * 编辑态常态
   */
  EDIT_NORMAL_STATE = MAIN_PAGE | EDIT,

  /**
   * 主页编辑态
   */
  EDIT_MAIN_PAGE_STATE_FULL = MAIN_PAGE | EDIT | 0x1,

  /**
   * 时钟编辑态
   */
  EDIT_CLOCK_STATE = MAIN_PAGE | EDIT | 0x2,

  /**
   * 卡片编辑态
   */
  EDIT_CARD_STATE = MAIN_PAGE | EDIT | 0x3,

  /**
   * 卡片编辑详情态
   */
  EDIT_CARD_DETAIL_STATE = MAIN_PAGE | EDIT | 0x4,

  /**
   * 壁纸编辑态
   */
  EDIT_WALLPAPER_STATE = MAIN_PAGE | EDIT | EDIT_EXTENSION | 0x5,

  /**
   * 熄屏风格编辑态
   */
  EDIT_AOD_STYLE_STATE = MAIN_PAGE | EDIT | EDIT_EXTENSION | 0x6,

  /**
   * 主题编辑态
   */
  EDIT_THEME_STATE = MAIN_PAGE | EDIT | EDIT_EXTENSION | 0x7,

  /**
   * 主题自定义编辑态
   */
  EDIT_CUSTOM_THEME_STATE = MAIN_PAGE | EDIT | EDIT_EXTENSION | 0x8,

  /**
   * 图库picker态
   */
  EDIT_CLOCK_PHOTO_PICKER_STATE = MAIN_PAGE | EDIT | EDIT_EXTENSION | 0x9,

  /**
   * Aod图库picker态
   */
  EDIT_AOD_PHOTO_PICKER_STATE = MAIN_PAGE | EDIT | 0xa,

  /**
   * 密码页态
   */
  BOUNCER_STATE = BOUNCER_PAGE,

  /**
   * 非锁屏态
   */
  UNLOCK_STATE = UNLOCK_PAGE,
}

/**
 * 主页状态机-状态类型工具类
 */
export class MpStateTypeUtils {
  private constructor() {
  }

  /**
   * 是否处于息屏态
   *
   * @param stateType 判断的状态
   * @returns true是/false否
   */
  public static isScreenOffState(stateType: MpStateType): boolean {
    return (stateType & SCREEN_OFF_PAGE) === SCREEN_OFF_PAGE;
  }

  /**
   * 是否处于主页态
   *
   * @param stateType 判断的状态
   * @returns true是/false否
   */
  public static isMainPageState(stateType: MpStateType): boolean {
    return (stateType & MAIN_PAGE) === MAIN_PAGE;
  }

  /**
   * 是否处于常态显示态
   *
   * @param stateType 判断的状态
   * @returns true是/false否
   */
  public static isNormalShowState(stateType: MpStateType): boolean {
    return (stateType & NORMAL_SHOW) === NORMAL_SHOW;
  }

  /**
   * 是否处于常态锁屏态
   *
   * @param stateType 判断的状态
   * @returns true是/false否
   */
  public static isNormalLockState(stateType: MpStateType): boolean {
    return stateType === MpStateType.NORMAL_LOCK_STATE;
  }

  /**
   * 是否处于常态解锁态
   *
   * @param stateType 判断的状态
   * @returns true是/false否
   */
  public static isNormalUnlockState(stateType: MpStateType): boolean {
    return stateType === MpStateType.NORMAL_UNLOCK_STATE;
  }

  /**
   * 是否处于假AOD态
   *
   * @param stateType 判断的状态
   * @returns true是/false否
   */
  public static isFakeAodState(stateType: MpStateType): boolean {
    return stateType === MpStateType.NORMAL_FAKE_AOD_STATE;
  }

  /**
   * 是否处于去激活态
   *
   * @param stateType 判断的状态
   * @returns true是/false否
   */
  public static isInactiveState(stateType: MpStateType): boolean {
    return stateType === MpStateType.INACTIVE_STATE;
  }

  /**
   * 是否处于密码校验态
   *
   * @param stateType 判断的状态
   * @returns true是/false否
   */
  public static isBouncerState(stateType: MpStateType): boolean {
    return stateType === MpStateType.BOUNCER_STATE;
  }

  /**
   * 是否处于编辑预览态
   *
   * @param stateType 判断的状态
   * @returns true是/false否
   */
  public static isEditPreviewState(stateType: MpStateType): boolean {
    return stateType === MpStateType.EDIT_NORMAL_STATE;
  }

  /**
   * 是否处于编辑态
   *
   * @param stateType 判断的状态
   * @returns true是/false否
   */
  public static isEditState(stateType: MpStateType): boolean {
    return (stateType & EDIT) === EDIT;
  }

  /**
   * 是否处于外部接入编辑态
   *
   * @param stateType 判断的状态
   * @returns true是/false否
   */
  public static isEditExtensionState(stateType: MpStateType): boolean {
    return (stateType & EDIT_EXTENSION) === EDIT_EXTENSION;
  }

  /**
   * 是否处于编辑全屏态
   *
   * @param stateType 判断的状态
   * @returns true是/false否
   */
  public static isEditFullState(stateType: MpStateType): boolean {
    return stateType === MpStateType.EDIT_MAIN_PAGE_STATE_FULL || stateType === MpStateType.EDIT_CLOCK_STATE ||
      stateType === MpStateType.EDIT_CARD_STATE || stateType === MpStateType.EDIT_CARD_DETAIL_STATE;
  }

  /**
   * 是否处于编辑时钟态
   *
   * @param stateType 判断的状态
   * @returns true是/false否
   */
  public static isEditClockState(stateType: MpStateType): boolean {
    return stateType === MpStateType.EDIT_CLOCK_STATE;
  }

  /**
   * 是否处于编辑扩展态
   *
   * @param stateType 判断的状态
   * @returns true是/false否
   */
  public static isEditExtendState(stateType: MpStateType): boolean {
    return stateType === MpStateType.EDIT_WALLPAPER_STATE || stateType === MpStateType.EDIT_AOD_STYLE_STATE ||
      stateType === MpStateType.EDIT_THEME_STATE || stateType === MpStateType.EDIT_CUSTOM_THEME_STATE ||
      stateType === MpStateType.EDIT_AOD_PHOTO_PICKER_STATE;
  }

  /**
   * 是否处于解锁态
   *
   * @param stateType 判断的状态
   * @returns true是/false否
   */
  public static isUnlockState(stateType: MpStateType): boolean {
    return stateType === MpStateType.UNLOCK_STATE;
  }

  /**
   * 时钟编辑的拉起图库Picker状态
   *
   * @param stateType 判断的状态
   * @returns true是/false否
   */
  public static isEditClockPickerState(stateType: MpStateType): boolean {
    return stateType === MpStateType.EDIT_CLOCK_PHOTO_PICKER_STATE;
  }

  /**
   * Aod编辑的拉起图库Picker状态
   *
   * @param stateType 判断的状态
   * @returns true是/false否
   */
  public static isEditAodPickerState(stateType: MpStateType): boolean {
    return stateType === MpStateType.EDIT_AOD_PHOTO_PICKER_STATE;
  }
}

/**
 * 定义：主页状态机-事件类型
 */
export enum MpEventType {
  /**
   * 进入熄屏态（由主状态机映射）
   */
  ENTER_SCREEN_OFF,

  /**
   * 进入主页锁屏态（由主状态机映射）
   */
  ENTER_MAIN_PAGE_LOCK,

  /**
   * 进入主页去激活态（由主状态机映射）
   */
  ENTER_MAIN_PAGE_INACTIVE,

  /**
   * 进入主页解锁态（由主状态机映射）
   */
  ENTER_MAIN_PAGE_UNLOCK,

  /**
   * 进入主页编辑态（由主状态机映射）
   */
  ENTER_MAIN_PAGE_EDIT,

  /**
   * 进入主页假AOD态（由主状态机映射）
   */
  ENTER_MAIN_PAGE_FAKE_AOD,

  /**
   * 进入密码页态（由主状态机映射）
   */
  ENTER_BOUNCER,

  /**
   * 进入未锁屏态（由主状态机映射）
   */
  ENTER_UNLOCK,

  /**
   * 侧滑返回
   */
  SLIDE_BACK,

  /**
   * 进入主页编辑态（1、点击空白处）
   */
  ENTER_EDIT_MAIN_PAGE_FULL,

  /**
   * 进入编辑时钟（1、点击时钟）
   */
  ENTER_EDIT_CLOCK,

  /**
   * 进入主页编辑态（1、点击卡片）
   */
  ENTER_EDIT_CARD,

  /**
   * 进入主页编辑态（1、点击卡片半模弹框应用）
   */
  ENTER_EDIT_CARD_DETAIL,

  /**
   * 进入编辑壁纸（点击壁纸按钮）
   */
  ENTER_EDIT_WALLPAPER,

  /**
   * 进入编辑熄屏风格（点击熄屏风格按钮）
   */
  ENTER_EDIT_AOD_STYLE,

  /**
   * 进入编辑主题（点击主题按钮）
   */
  ENTER_EDIT_THEME,

  /**
   * 进入自定义主题（点击自定义主题按钮）
   */
  ENTER_EDIT_CUSTOM_THEME,

  /**
   * 进入时钟编辑-图库态
   */
  ENTER_EDIT_CLOCK_PHOTO_PICKER,

  /**
   * 进入Aod编辑-图库态
   */
  ENTER_EDIT_AOD_PHOTO_PICKER,

  /**
   * 退出Aod编辑-图库态
   */
  EXIT_EDIT_AOD_PHOTO_PICKER,

  /**
   * 退出编辑壁纸（关闭壁纸编辑页面）;退出编辑熄屏风格（关闭熄屏风格编辑页面）;退出编辑主题（关闭主题编辑页面）；退出时钟编辑图库
   */
  EXIT_EDIT_EXTENSION,

  /**
   * 退出全屏编辑态，进入编辑引导页面：1、点击返回键；
   */
  EXIT_EDIT_MAIN_PAGE_STATE_FULL_BACK,
}

/**
 * 主页状态机事件
 */
export class MpEvent extends AbstractEvent<MpEventType> {
  public toString(): string {
    return MpEventType[this.eventType] ?? 'Unknown_MpEvent';
  }
}

/**
 * 抽象主页状态
 */
abstract class AbstractMpState extends AbstractState<MpStateType, MpEvent> {
  public toString(): string {
    return MpStateType[this.stateType] ?? 'Unknown_MpState';
  }
}

/**
 * 主状态映射态
 */
abstract class CoreMappingState extends AbstractMpState {
  public handleEvent(event: MpEvent): MpStateType | AbstractState<MpStateType, MpEvent> {
    switch (event.eventType) {
      case MpEventType.ENTER_SCREEN_OFF:
        return MpStateType.SCREEN_OFF_STATE;
      case MpEventType.ENTER_MAIN_PAGE_LOCK:
        return MpStateType.NORMAL_LOCK_STATE;
      case MpEventType.ENTER_MAIN_PAGE_INACTIVE:
        return MpStateType.INACTIVE_STATE;
      case MpEventType.ENTER_MAIN_PAGE_UNLOCK:
        return MpStateType.NORMAL_UNLOCK_STATE;
      case MpEventType.ENTER_MAIN_PAGE_EDIT:
        return MpStateType.EDIT_NORMAL_STATE;
      case MpEventType.ENTER_MAIN_PAGE_FAKE_AOD:
        return MpStateType.NORMAL_FAKE_AOD_STATE;
      case MpEventType.ENTER_BOUNCER:
        return MpStateType.BOUNCER_STATE;
      case MpEventType.ENTER_UNLOCK:
        return MpStateType.UNLOCK_STATE;
    }
    return this.stateType; // 默认不做状态转移
  }
}

/**
 * 初始态
 */
class InitState extends CoreMappingState {
  public handleEvent(event: MpEvent): MpStateType | AbstractState<MpStateType, MpEvent> {
    return super.handleEvent(event);
  }
}

/**
 * 熄屏态
 */
class ScreenOffState extends CoreMappingState {
  public handleEvent(event: MpEvent): MpStateType | AbstractState<MpStateType, MpEvent> {
    return super.handleEvent(event);
  }
}

/**
 * 常态锁屏态
 */
class NormalLockState extends CoreMappingState {
  public handleEvent(event: MpEvent): MpStateType | AbstractState<MpStateType, MpEvent> {
    return super.handleEvent(event);
  }
}

/**
 * 去激活态
 */
class InactiveState extends CoreMappingState {
  public handleEvent(event: MpEvent): MpStateType | AbstractState<MpStateType, MpEvent> {
    return super.handleEvent(event);
  }
}

/**
 * 常态解锁态
 */
class NormalUnlockState extends CoreMappingState {
  public handleEvent(event: MpEvent): MpStateType | AbstractState<MpStateType, MpEvent> {
    return super.handleEvent(event);
  }
}

/**
 * 假AOD态
 */
class FakeAodState extends CoreMappingState {
  public handleEvent(event: MpEvent): MpStateType | AbstractState<MpStateType, MpEvent> {
    return super.handleEvent(event);
  }
}

/**
 * 编辑态
 */
abstract class EditState extends CoreMappingState {
  public handleEvent(event: MpEvent): MpStateType | AbstractState<MpStateType, MpEvent> {
    if (event.eventType === MpEventType.ENTER_MAIN_PAGE_EDIT) {
      return this.stateType; // 切到自身时，不处理
    }
    return super.handleEvent(event);
  }
}

/**
 * 编辑态常态
 */
class EditNormalState extends EditState {
  public handleEvent(event: MpEvent): MpStateType | AbstractState<MpStateType, MpEvent> {
    switch (event.eventType) {
      case MpEventType.SLIDE_BACK:
        return MpStateType.NORMAL_UNLOCK_STATE;
      case MpEventType.ENTER_EDIT_MAIN_PAGE_FULL:
        return MpStateType.EDIT_MAIN_PAGE_STATE_FULL;
      case MpEventType.ENTER_EDIT_CLOCK:
        return MpStateType.EDIT_CLOCK_STATE;
      case MpEventType.ENTER_EDIT_CARD:
        return MpStateType.EDIT_CARD_STATE;
      case MpEventType.ENTER_EDIT_WALLPAPER:
        return MpStateType.EDIT_WALLPAPER_STATE;
      case MpEventType.ENTER_EDIT_AOD_STYLE:
        return MpStateType.EDIT_AOD_STYLE_STATE;
      case MpEventType.ENTER_EDIT_THEME:
        return MpStateType.EDIT_THEME_STATE;
      case MpEventType.ENTER_EDIT_CUSTOM_THEME:
        return MpStateType.EDIT_CUSTOM_THEME_STATE;
    }
    return super.handleEvent(event);
  }
}

/**
 * 主页编辑态
 */
class EditMainPageState extends EditState {
  public handleEvent(event: MpEvent): MpStateType | AbstractState<MpStateType, MpEvent> {
    switch (event.eventType) {
      case MpEventType.SLIDE_BACK:
      case MpEventType.EXIT_EDIT_MAIN_PAGE_STATE_FULL_BACK:
        return MpStateType.EDIT_NORMAL_STATE;
      case MpEventType.ENTER_EDIT_CLOCK:
        return MpStateType.EDIT_CLOCK_STATE;
      case MpEventType.ENTER_EDIT_CARD:
        return MpStateType.EDIT_CARD_STATE;
    }
    return super.handleEvent(event);
  }
}

/**
 * 时钟编辑态
 */
class EditClockState extends EditState {
  public handleEvent(event: MpEvent): MpStateType | AbstractState<MpStateType, MpEvent> {
    switch (event.eventType) {
      case MpEventType.SLIDE_BACK:
      case MpEventType.EXIT_EDIT_MAIN_PAGE_STATE_FULL_BACK:
        return MpStateType.EDIT_NORMAL_STATE;
      case MpEventType.ENTER_EDIT_MAIN_PAGE_FULL:
        return MpStateType.EDIT_MAIN_PAGE_STATE_FULL;
      case MpEventType.ENTER_EDIT_CARD:
        return MpStateType.EDIT_CARD_STATE;
      case MpEventType.ENTER_EDIT_CLOCK_PHOTO_PICKER:
        return MpStateType.EDIT_CLOCK_PHOTO_PICKER_STATE;
    }
    return super.handleEvent(event);
  }
}

/**
 * 卡片编辑态
 */
class EditCardState extends EditState {
  public handleEvent(event: MpEvent): MpStateType | AbstractState<MpStateType, MpEvent> {
    switch (event.eventType) {
      case MpEventType.SLIDE_BACK:
      case MpEventType.ENTER_EDIT_MAIN_PAGE_FULL:
        return MpStateType.EDIT_MAIN_PAGE_STATE_FULL;
      case MpEventType.EXIT_EDIT_MAIN_PAGE_STATE_FULL_BACK:
        return MpStateType.EDIT_NORMAL_STATE;
      case MpEventType.ENTER_EDIT_CLOCK:
        return MpStateType.EDIT_CLOCK_STATE;
      case MpEventType.ENTER_EDIT_CARD_DETAIL:
        return MpStateType.EDIT_CARD_DETAIL_STATE;
    }
    return super.handleEvent(event);
  }
}

/**
 * 卡片编辑详情态
 */
class EditCardDetailState extends EditCardState {
  public handleEvent(event: MpEvent): MpStateType | AbstractState<MpStateType, MpEvent> {
    switch (event.eventType) {
      case MpEventType.SLIDE_BACK:
        return MpStateType.EDIT_CARD_STATE;
    }
    return super.handleEvent(event);
  }
}

/**
 * 壁纸编辑态
 */
class EditWallpaperState extends EditState {
  public handleEvent(event: MpEvent): MpStateType | AbstractState<MpStateType, MpEvent> {
    switch (event.eventType) {
      case MpEventType.SLIDE_BACK:
      case MpEventType.EXIT_EDIT_EXTENSION:
        return MpStateType.EDIT_NORMAL_STATE;
    }
    return super.handleEvent(event);
  }
}

/**
 * 熄屏风格编辑态
 */
class EditAodStyleState extends EditState {
  public handleEvent(event: MpEvent): MpStateType | AbstractState<MpStateType, MpEvent> {
    switch (event.eventType) {
      case MpEventType.SLIDE_BACK:
      case MpEventType.EXIT_EDIT_EXTENSION:
        return MpStateType.EDIT_NORMAL_STATE;
      case MpEventType.ENTER_EDIT_AOD_PHOTO_PICKER:
        return MpStateType.EDIT_AOD_PHOTO_PICKER_STATE;
    }
    return super.handleEvent(event);
  }
}

/**
 * 自定义主题态
 */
class EditCustomThemeState extends EditState {
  public handleEvent(event: MpEvent): MpStateType | AbstractState<MpStateType, MpEvent> {
    switch (event.eventType) {
      case MpEventType.SLIDE_BACK:
      case MpEventType.EXIT_EDIT_EXTENSION:
        return MpStateType.EDIT_NORMAL_STATE;
    }
    return super.handleEvent(event);
  }
}

/**
 * photopicker态
 */
class EditClockPhotoPickerState extends EditState {
  public handleEvent(event: MpEvent): MpStateType | AbstractState<MpStateType, MpEvent> {
    switch (event.eventType) {
      case MpEventType.SLIDE_BACK:
      case MpEventType.EXIT_EDIT_EXTENSION:
        return MpStateType.EDIT_CLOCK_STATE;
    }
    return super.handleEvent(event);
  }
}

/**
 * AodPhotoPicker态
 */
class EditAodPhotoPickerState extends EditState {
  public handleEvent(event: MpEvent): MpStateType | AbstractState<MpStateType, MpEvent> {
    switch (event.eventType) {
      case MpEventType.SLIDE_BACK:
      case MpEventType.EXIT_EDIT_AOD_PHOTO_PICKER:
        return MpStateType.EDIT_AOD_STYLE_STATE;
    }
    return super.handleEvent(event);
  }
}

/**
 * 主题编辑态
 */
class EditThemeState extends EditState {
  public handleEvent(event: MpEvent): MpStateType | AbstractState<MpStateType, MpEvent> {
    switch (event.eventType) {
      case MpEventType.SLIDE_BACK:
      case MpEventType.EXIT_EDIT_EXTENSION:
        return MpStateType.EDIT_NORMAL_STATE;
    }
    return super.handleEvent(event);
  }
}

/**
 * 密码页态
 */
class BouncerState extends CoreMappingState {
  public handleEvent(event: MpEvent): MpStateType | AbstractState<MpStateType, MpEvent> {
    return super.handleEvent(event);
  }
}

/**
 * 未锁屏态
 */
class UnlockState extends CoreMappingState {
  public handleEvent(event: MpEvent): MpStateType | AbstractState<MpStateType, MpEvent> {
    return super.handleEvent(event);
  }
}

/**
 * 主页状态工厂
 */
class MpStateFactory extends AbstractStateFactory<MpStateType, MpEvent> {
  constructor() {
    super();
    this.addSateConstructor(MpStateType.INIT_STATE, (stateType: MpStateType) => new InitState(stateType));
    this.addSateConstructor(MpStateType.SCREEN_OFF_STATE, (stateType: MpStateType) => new ScreenOffState(stateType));
    this.addSateConstructor(MpStateType.NORMAL_LOCK_STATE, (stateType: MpStateType) => new NormalLockState(stateType));
    this.addSateConstructor(MpStateType.INACTIVE_STATE, (stateType: MpStateType) => new InactiveState(stateType));
    this.addSateConstructor(MpStateType.NORMAL_UNLOCK_STATE,
      (stateType: MpStateType) => new NormalUnlockState(stateType));
    this.addSateConstructor(MpStateType.NORMAL_FAKE_AOD_STATE, (stateType: MpStateType) => new FakeAodState(stateType));
    this.addSateConstructor(MpStateType.EDIT_NORMAL_STATE, (stateType: MpStateType) => new EditNormalState(stateType));
    this.addSateConstructor(MpStateType.EDIT_MAIN_PAGE_STATE_FULL,
      (stateType: MpStateType) => new EditMainPageState(stateType));
    this.addSateConstructor(MpStateType.EDIT_CLOCK_STATE, (stateType: MpStateType) => new EditClockState(stateType));
    this.addSateConstructor(MpStateType.EDIT_CARD_STATE, (stateType: MpStateType) => new EditCardState(stateType));
    this.addSateConstructor(MpStateType.EDIT_CARD_DETAIL_STATE,
      (stateType: MpStateType) => new EditCardDetailState(stateType));
    this.addSateConstructor(MpStateType.EDIT_WALLPAPER_STATE,
      (stateType: MpStateType) => new EditWallpaperState(stateType));
    this.addSateConstructor(MpStateType.EDIT_AOD_STYLE_STATE,
      (stateType: MpStateType) => new EditAodStyleState(stateType));
    this.addSateConstructor(MpStateType.EDIT_THEME_STATE, (stateType: MpStateType) => new EditThemeState(stateType));
    this.addSateConstructor(MpStateType.EDIT_CUSTOM_THEME_STATE,
      (stateType: MpStateType) => new EditCustomThemeState(stateType));
    this.addSateConstructor(MpStateType.BOUNCER_STATE, (stateType: MpStateType) => new BouncerState(stateType));
    this.addSateConstructor(MpStateType.UNLOCK_STATE, (stateType: MpStateType) => new UnlockState(stateType));
    this.addSateConstructor(MpStateType.EDIT_CLOCK_PHOTO_PICKER_STATE,
      (stateType: MpStateType) => new EditClockPhotoPickerState(stateType));
    this.addSateConstructor(MpStateType.EDIT_AOD_PHOTO_PICKER_STATE,
      (stateType: MpStateType) => new EditAodPhotoPickerState(stateType));
  }
}

/**
 * 定义匹配规则接口
 */
interface MpMatchRule extends MatchRule<CoreStateType, CoreEvent, MpEventType | undefined> {
  matched: (oldState: CoreStateType, newState: CoreStateType, event?: CoreEvent) => MpEventType | undefined;
}

/**
 * 主页状态机匹配规则
 */
const MP_FSM_MATCH_RULES: MpMatchRule[] =
  [
    // 进入熄屏态
    {
      matched: (oldState: CoreStateType, newState: CoreStateType): MpEventType | undefined => {
        if (!CoreStateTypeUtils.isInScreenOff(oldState) && CoreStateTypeUtils.isInScreenOff(newState)) {
          return MpEventType.ENTER_SCREEN_OFF;
        }
        return undefined;
      }
    },
    // 进入主页常规锁屏态
    {
      matched: (oldState: CoreStateType, newState: CoreStateType, event?: CoreEvent): MpEventType | undefined => {
        if (event?.eventType === CoreEventType.USER_DEACTIVATE && newState === CoreStateType.MAIN_PAGE_LOCK_STATE) {
          return MpEventType.ENTER_MAIN_PAGE_INACTIVE;
        }
        if ((event?.eventType === CoreEventType.USER_ACTIVATE || oldState !== CoreStateType.MAIN_PAGE_LOCK_STATE) &&
          newState === CoreStateType.MAIN_PAGE_LOCK_STATE) {
          return MpEventType.ENTER_MAIN_PAGE_LOCK;
        }
        return undefined;
      }
    },
    // 进入主页常规解锁态
    {
      matched: (oldState: CoreStateType, newState: CoreStateType): MpEventType | undefined => {
        if (oldState !== CoreStateType.MAIN_PAGE_UNLOCK_STATE && newState === CoreStateType.MAIN_PAGE_UNLOCK_STATE) {
          return MpEventType.ENTER_MAIN_PAGE_UNLOCK;
        }
        return undefined;
      }
    },
    // 进入主页编辑态
    {
      matched: (oldState: CoreStateType, newState: CoreStateType): MpEventType | undefined => {
        if (!CoreStateTypeUtils.isInEditMainPage(oldState) && CoreStateTypeUtils.isInEditMainPage(newState)) {
          return MpEventType.ENTER_MAIN_PAGE_EDIT;
        }
        return undefined;
      }
    },
    // 进入主页假AOD态
    {
      matched: (oldState: CoreStateType, newState: CoreStateType): MpEventType | undefined => {
        if (!CoreStateTypeUtils.isInFakeAodMainPage(oldState) && CoreStateTypeUtils.isInFakeAodMainPage(newState)) {
          return MpEventType.ENTER_MAIN_PAGE_FAKE_AOD;
        }
        return undefined;
      }
    },
    // 进入密码页态
    {
      matched: (oldState: CoreStateType, newState: CoreStateType): MpEventType | undefined => {
        if (!CoreStateTypeUtils.isInBouncePage(oldState) && CoreStateTypeUtils.isInBouncePage(newState)) {
          return MpEventType.ENTER_BOUNCER;
        }
        return undefined;
      }
    },
    // 进入未锁屏态
    {
      matched: (oldState: CoreStateType, newState: CoreStateType): MpEventType | undefined => {
        if (oldState !== CoreStateType.UNLOCK_STATE && newState === CoreStateType.UNLOCK_STATE) {
          return MpEventType.ENTER_UNLOCK;
        }
        return undefined;
      }
    },
  ];

/**
 * 定义锁屏的主页状态机
 */
export class MainPageFsm extends AbstractFsm<MpStateType, MpEvent> {
  constructor(persistentId: number) {
    super(TAG + persistentId, MpStateType.INIT_STATE, new MpStateFactory());
  }

  /**
   * 提交核心状态机事件
   *
   * @param eventIn 状态机事件
   */
  public submitEvent(eventIn: MpEvent | MpEventType): void {
    let event: MpEvent;
    if (eventIn instanceof MpEvent) {
      event = eventIn as MpEvent;
    } else {
      event = new MpEvent(eventIn as MpEventType);
    }
    log.showInfo('submitEvent:' + event.toString());
    this.processEvent(event);
  }

  /**
   * 映射主状态机状态变更
   *
   * @param oldState 主状态机原状态
   * @param newState 主状态机新状态
   * @param event 状态机事件
   */
  public matchCoreFsmChange(oldState: CoreStateType, newState: CoreStateType, event?: CoreEvent): void {
    for (let matchRule of MP_FSM_MATCH_RULES) {
      let eventType: MpEventType | undefined = matchRule.matched(oldState, newState, event);
      if (eventType !== undefined) {
        this.submitEvent(eventType);
        break;
      }
    }
  }
}