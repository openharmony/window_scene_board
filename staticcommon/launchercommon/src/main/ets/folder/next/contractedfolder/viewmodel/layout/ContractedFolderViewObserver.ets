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

import { CheckEmptyUtils, LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/TsIndex';
import { NumberConstants } from '@ohos/commonconstants/src/main/ets/TsIndex';
import { AppIconData } from '../../../../../launchericon/viewmodel/AppIconData';
import { AppNameModifier } from '../../../../../uicomponents/AppName';
import { FolderAnimationPlaybackManager } from '../../../common/dfx/playback/FolderAnimationPlaybackManager';
import { ATTRIBUTE_TYPE, OBSERVER_SWITCH, OBSERVER_TYPE } from '../../../common/FolderCommonConstant';
import { FolderCommonUtil } from '../../../common/FolderCommonUtil';
import { BackgroundObserver } from '../../../common/observer/BackgroundObserver';
import { BaseObserver } from '../../../common/observer/BaseObserver';
import { FolderIconObserver } from '../../../common/observer/FolderIconObserver';
import { FolderObserver } from '../../../common/observer/FolderObserver';
import { IObserver } from '../../../common/observer/IObserver';
import { ResizeObserver } from '../../../common/observer/ResizeObserver';
import { ContractedFolderObserver } from './ContractedFolderObserver';
import { ContractedFolderObserverType } from './IContractedFolderObserver';
import { ContractedFolderLayoutStyle } from './style/ContractedFolderLayoutStyleFactory';
import GridLayoutItemInfo from '../../../../../bean/GridLayoutItemInfo';
import { FolderAppItemInfo } from '../../../../FolderItemInfo';
import { CommonConstants } from '../../../../../constants/CommonConstants';

const TAG = 'ContractedFolderViewObserver';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);
const KEY_ITEM: string = 'FolderIconKey';

/**
 * 折叠态文件夹View组件的控制接口，仅对View使用，布局状态变量，屏蔽Track变量，避免被其他ViewModel直接修改
 */
export class ContractedFolderViewObserver extends ContractedFolderObserver {
  @Track private key: string = TAG;
  @Track private cycle: FolderAnimationPlaybackManager = FolderAnimationPlaybackManager.getInstance();
  protected type: number = ContractedFolderObserverType.CONTRACTED_FOLDER_VIEW;
  /* 折叠文件夹状态变量结合，包含背板、网格及网格内容、文件夹名字 */
  @Track public folderOsr: FolderObserver = new FolderObserver();
  @Track public folderAppNameModify: AppNameModifier = new AppNameModifier();
  /* 文件夹调整大小 */
  @Track public resizeOsr: ResizeObserver = new ResizeObserver();
  /* 文件夹显示隐藏 */
  @Track public isFolderVisible: boolean = true;
  /* 文件夹图标状态变量集合，包含背板、网格及网格内容，不包含文件夹名字 */
  @Track public folderIconOsr: BaseObserver = new BaseObserver();
  /* 背板相关状态变量 */
  @Track public folderBgOsr: BackgroundObserver = new BackgroundObserver();
  /* 三个堆叠图标状态变量集合 */
  @Track public spIconOsrFst: BaseObserver = new BaseObserver();
  @Track public spIconOsrSnd: BaseObserver = new BaseObserver();
  @Track public spIconOsrTrd: BaseObserver = new BaseObserver();
  /* 占位图标状态变量集合 */
  @Track public phIconOsrFst: BaseObserver = new BaseObserver();
  @Track public phIconOsrSnd: BaseObserver = new BaseObserver();
  /* 堆叠图标使用：拖拽或解散动效图标组件状态变量 */
  @Track public aniIconOsr: BaseObserver = new BaseObserver();
  /* 预览两个供文件动效节点使用的observer */
  @Track public iconOsr: FolderIconObserver = new FolderIconObserver();
  @Track public sndIconOsr: FolderIconObserver = new FolderIconObserver();
  @Track public enableFolderName: boolean = true;
  @Track public enableMultiSelectBox: boolean = true;
  /* 是否显示文件夹编辑态 */
  @Track public editFolderMode: boolean = false;
  /* 是否显示菜单 */
  @Track public isMenuShow: boolean = false;
  @Track public isHiddenEffect: boolean = false;
  /* 是否处于文件夹大小转换 */
  @Track public isFolderChange: boolean = false;
  /* 下载中背板透明度 */
  @Track public downloadingOpacity: number = 0;
  /* 是否显示现在进度 */
  @Track public isShowProgress: boolean = false;
  /* 是否隐藏下载背板 */
  @Track public mIsHideMask: boolean = false;
  /* 是否显示小文件夹尾页截图 */
  @Track public isShowEndPage: boolean = false;
  /* 堆叠应用退出标志 */
  @Track public mLastFlag: boolean = false;
  /* FolderViewData回弹动效相关 */
  @Track public isAnimating: boolean = false;
  /* 文件夹图标动效标志 拖拽、解散等场景 */
  @Track public mIsIconAnimating: boolean = false;
  /* 大小转换动效中 */
  @Track public isConvert: boolean = false;
  /* 当前页是否显示 */
  @Track public isShowCurrentPage: boolean = false;

  /**
   * 注册observer
   *
   * @param folderId 文件夹id
   */
  public register(folderId: string): void {
    super.register(folderId);
    this.key = folderId + '_contracted_folder_observer';
  }

  /**
   * 初始化布局样式的observer
   *
   * @param layoutStyle 文件夹样式
   */
  public initObserver(layoutStyle: ContractedFolderLayoutStyle, fstData: AppIconData, sndData: AppIconData,
    isEnableName: boolean): void {
    let tmpFolderOsr: FolderObserver = new FolderObserver();
    tmpFolderOsr.folderWidth = layoutStyle.backgroundWidth;
    tmpFolderOsr.folderHeight = layoutStyle.backgroundHeight;
    tmpFolderOsr.folderRadius = layoutStyle.backgroundRadius;
    tmpFolderOsr.initTemplate(layoutStyle.countInColumn, layoutStyle.countInRow);
    this.folderOsr = tmpFolderOsr;
    // 背板实际绑定 resizeOsr.backgroundRadius，必须同步圆形半径，否则桌面稳态仍为默认圆角方形
    this.resizeOsr.init(layoutStyle);
    this.folderBgOsr.init(FolderCommonUtil.isDockFolder(this.folderId));
    this.iconOsr.setIconData(fstData);
    this.sndIconOsr.setIconData(sndData);
    this.enableFolderName = isEnableName;
  }

  /**
   * 获取子控件的observer
   *
   * @param msg DFX的日志打印
   * @param type OBSERVER_TYPE组件observer的类型
   * @returns 子组件observer
   */
  public getChildOsr(msg: string, type: number): IObserver {
    log.showInfo('(%{public}s): get folder %{public}s child observer type %{public}d', msg, this.key, type);
    let osr: IObserver = new BaseObserver();
    switch (type) {
      case OBSERVER_TYPE.FOLDER:
        osr = this.folderOsr;
        break;
      case OBSERVER_TYPE.FOLDER_ICON:
        osr = this.folderIconOsr;
        break;
      case OBSERVER_TYPE.FOLDER_BG:
        osr = this.folderBgOsr;
        break;
      case OBSERVER_TYPE.ANI_ICON:
        osr = this.aniIconOsr;
        break;
      case OBSERVER_TYPE.SP_ICON_FST:
        osr = this.spIconOsrFst;
        break;
      case OBSERVER_TYPE.SP_ICON_SND:
        osr = this.spIconOsrSnd;
        break;
      case OBSERVER_TYPE.SP_ICON_TRD:
        osr = this.spIconOsrTrd;
        break;
      case OBSERVER_TYPE.PH_ICON_FST:
        osr = this.phIconOsrFst;
        break;
      case OBSERVER_TYPE.PH_ICON_SND:
        osr = this.phIconOsrSnd;
        break;
      case OBSERVER_TYPE.ICON_DATA:
        osr = this.iconOsr;
        break;
      case OBSERVER_TYPE.SND_ICON_DATA:
        osr = this.sndIconOsr;
        break;
      default:
        log.showError('the component for type %{public}d can not find', type);
    }
    return osr;
  }

  /**
   * 设置文件夹开关变量的状态
   *
   * @param msg 用于DFX的日志
   * @param type 开关变量的类型
   * @param isOn 状态
   */
  public setStatus(msg: string, type: number, isOn: boolean): void {
    log.showInfo('%{public}s, update folder %{public}s switch %{public}d status %{public}s', msg, this.key, type, isOn);
    switch (type) {
      case OBSERVER_SWITCH.MENU_SHOW:
        this.isMenuShow = isOn;
        break;
      case OBSERVER_SWITCH.MENU_EFFECT_HIDE:
        this.isHiddenEffect = isOn;
        break;
      case OBSERVER_SWITCH.FOLDER_CHANGE:
        this.isFolderChange = isOn;
        break;
      case OBSERVER_SWITCH.FOLDER_VISIBLE:
        this.isFolderVisible = isOn;
        this.folderIconOsr.opacity = isOn ? 1 : 0.0005;
        break;
      case OBSERVER_SWITCH.PROGRESS_SHOW:
        this.isShowProgress = isOn;
        break;
      case OBSERVER_SWITCH.DOWNLOAD_MASK:
        this.mIsHideMask = isOn;
        break;
      case OBSERVER_SWITCH.END_PAGE_SHOW:
        this.isShowEndPage = isOn;
        break;
      case OBSERVER_SWITCH.CURRENT_PAGE_SHOW:
        this.isShowCurrentPage = isOn;
        break;
      case OBSERVER_SWITCH.LAST_APP_SHOW:
        this.mLastFlag = isOn;
        break;
      case OBSERVER_SWITCH.RESIZE_ANIMATE:
        this.isAnimating = isOn;
        break;
      case OBSERVER_SWITCH.EDIT_FOLDER_MODE:
        this.editFolderMode = isOn;
        break;
      case OBSERVER_SWITCH.ICON_ANIMATE:
        this.mIsIconAnimating = isOn;
        break;
      case OBSERVER_SWITCH.FOLDER_CHECK_BOX:
        this.enableMultiSelectBox = isOn;
        break;
      case OBSERVER_SWITCH.CONVERT_ANIMATE:
        this.isConvert = isOn;
        break;
      default:
        log.showError('update folder %{public}s status error for not find switch type %{public}d', this.key, type);
        break
    }
  }

  /**
   * 获取文件夹开关变量的状态
   *
   * @param type 开关变量的类型
   * @returns
   */
  public getStatus(type: number): boolean {
    switch (type) {
      case OBSERVER_SWITCH.MENU_SHOW:
        return this.isMenuShow;
      case OBSERVER_SWITCH.MENU_EFFECT_HIDE:
        return this.isHiddenEffect;
      case OBSERVER_SWITCH.FOLDER_CHANGE:
        return this.isFolderChange;
      case OBSERVER_SWITCH.FOLDER_VISIBLE:
        return this.isFolderVisible;
      case OBSERVER_SWITCH.PROGRESS_SHOW:
        return this.isShowProgress;
      case OBSERVER_SWITCH.DOWNLOAD_MASK:
        return this.mIsHideMask;
      case OBSERVER_SWITCH.END_PAGE_SHOW:
        return this.isShowEndPage;
      case OBSERVER_SWITCH.CURRENT_PAGE_SHOW:
        return this.isShowCurrentPage;
      case OBSERVER_SWITCH.LAST_APP_SHOW:
        return this.mLastFlag;
      case OBSERVER_SWITCH.RESIZE_ANIMATE:
        return this.isAnimating;
      case OBSERVER_SWITCH.EDIT_FOLDER_MODE:
        return this.editFolderMode;
      case OBSERVER_SWITCH.ICON_ANIMATE:
        return this.mIsIconAnimating;
      case OBSERVER_SWITCH.FOLDER_CHECK_BOX:
        return this.enableMultiSelectBox;
      case OBSERVER_SWITCH.CONVERT_ANIMATE:
        return this.isConvert;
      default:
        break;
    }
    return false;
  }

  /**
   * 设置文件夹名字透明度
   *
   * @param opacity 透明度
   */
  public setFolderTitleOpacity(msg: string, opacity: number): void {
    this.folderAppNameModify.attribute?.opacity(opacity);
  }

  /**
   * 设置下载透明度变化
   *
   * @param opacity 透明度
   */
  public setDownloadOpacity(msg: string, opacity: number): void {
    this.cycle.record(this.key, msg, Number(this.downloadingOpacity), Number(opacity), 0, 0, -1);
    this.downloadingOpacity = opacity;
  }

  /**
   * 获取下载背板的透明度
   *
   * @returns downloadingOpacity
   */
  public getDownloadOpacity(): number {
    return this.downloadingOpacity;
  }

  /**
   * 获取堆叠中应用的透明度
   *
   * @param index 元素在堆叠中的序号
   * @returns 透明度
   */
  public getLastAppOpacity(index: number): number {
    switch (index) {
      case NumberConstants.CONSTANT_NUMBER_TWO: // ninth app opacity
        return this.spIconOsrTrd.getAttribute(ATTRIBUTE_TYPE.OPACITY);
      case NumberConstants.CONSTANT_NUMBER_ONE: // tenth app opacity
        return this.spIconOsrSnd.getAttribute(ATTRIBUTE_TYPE.OPACITY);
      case NumberConstants.CONSTANT_NUMBER_ZERO: // eleventh app opacity
        return this.spIconOsrFst.getAttribute(ATTRIBUTE_TYPE.OPACITY);
      default:
        return 1;
    }
  }

  /**
   * 获取堆叠中应用的位置
   *
   * @param index 元素在堆叠中的序号
   * @returns 位置x
   */
  public getLastAppPositionX(index: number): number {
    switch (index) {
      case NumberConstants.CONSTANT_NUMBER_TWO: // ninth app position
        return this.spIconOsrTrd.getAttribute(ATTRIBUTE_TYPE.OFFSET_X);
      case NumberConstants.CONSTANT_NUMBER_ONE: // tenth app position
        return this.spIconOsrSnd.getAttribute(ATTRIBUTE_TYPE.OFFSET_X);
      case NumberConstants.CONSTANT_NUMBER_ZERO: // eleventh app position
        return this.spIconOsrFst.getAttribute(ATTRIBUTE_TYPE.OFFSET_X);
      default:
        return NumberConstants.CONSTANT_NUMBER_ZERO;
    }
  }

  /**
   * 获取堆叠中应用的位置
   *
   * @param index 元素在堆叠中的序号
   * @returns 位置y
   */
  public getLastAppPositionY(index: number): number {
    switch (index) {
      case NumberConstants.CONSTANT_NUMBER_TWO: // ninth app position
        return this.spIconOsrTrd.getAttribute(ATTRIBUTE_TYPE.OFFSET_Y);
      case NumberConstants.CONSTANT_NUMBER_ONE: // tenth app position
        return this.spIconOsrSnd.getAttribute(ATTRIBUTE_TYPE.OFFSET_Y);
      case NumberConstants.CONSTANT_NUMBER_ZERO: // eleventh app position
        return this.spIconOsrFst.getAttribute(ATTRIBUTE_TYPE.OFFSET_Y);
      default:
        return NumberConstants.CONSTANT_NUMBER_ZERO;
    }
  }

  /**
   * 获取堆叠中占位图标的透明度
   *
   * @param index 元素在堆叠中的序号
   * @returns 透明度
   */
  public getLastHolderAppOpacity(index: number): number {
    switch (index) {
      case NumberConstants.CONSTANT_NUMBER_ONE: // tenth app opacity
        return this.phIconOsrSnd.getAttribute(ATTRIBUTE_TYPE.OPACITY);
      case NumberConstants.CONSTANT_NUMBER_ZERO: // eleventh app opacity
        return this.phIconOsrFst.getAttribute(ATTRIBUTE_TYPE.OPACITY);
      default:
        return NumberConstants.CONSTANT_NUMBER_ONE;
    }
  }

  /**
   * 获取当前observer类型，区分同一个folderId下，多个不同的observer
   *
   * @returns observer类型
   */
  public getObserverType(): number {
    return this.type;
  }
}