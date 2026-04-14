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
import fu from '@ohos.file.fileuri';
import { RTLUtil } from '@ohos/componenthelper';
import { LogDomain, LogHelper, FileUtils, SingletonHelper } from '@ohos/basicutils';
import { GlobalContext, DeviceHelper, HiSysReportEvent, ReportDomain } from '@ohos/frameworkwrapper';
import { editModeManager } from '@ohos/launchercommon';
import { PreferenceStore } from './dao/PreferenceStore';

const TAG: string = 'EditModeGuideManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

// 打点参数
const PNAMEID: string = 'com.ohos.sceneboard';
const PVERSIONID: string = 'sceneBoard';
const LAUNCHER_EDIT_MODE_GUIDE_EVENT: string = 'LAUNCHER_EDIT_MODE_GUIDE_EVENT';
// 动画地址及播放间隔
const RESOURCE_PATH: string = '/sys_prod/etc/pinchGestureGuide';
const FILE_NAME_PREFIX: string = 'pinch_gesture_guide_';
const FILE_SEPARATOR: string = '/';
const FILE_NAME_SUFFIX: string = '.png';
const ANIMATION_DURATION: number = 33;
const ANIMATION_DURATION_END: number = 1000;
// 引导页是否开启过本地持久化的key
const GUIDE_PREFERENCE_KEY: string = 'isOpenedEditModeGuide';

/**
 * 引导页打点事件状态
 */
export enum GuideReportStatus {
  /**
   * 打开引导页面
   */
  OPEN = 1,
  /**
   * 打开引导页面通过尾页滑动
   */
  OPEN_BY_SWIPE = 2,
  /**
   * 打开引导页面通过长按
   */
  OPEN_BY_LONG_CLICK = 3,
  /**
   * 关闭引导页面
   */
  CLOSE = 4,
}

/**
 * 引导页打点参数
 */
interface ReportParams {
  // 进程包名
  PNAMEID: string;

  // 进程名
  PVERSIONID: string;

  // 引导页打点事件状态
  EDIT_MODE_GUIDE_STATUS: GuideReportStatus;
}

/**
 * 外屏编辑模式引导提示页manager
 */
class EditModeGuideManager {
  private mOuterHomeReportEvent: HiSysReportEvent = HiSysReportEvent.getHiSysReportEvent(ReportDomain
    .OUTER_HOME_UE);
  private isOpenedEditModeGuide: boolean = false;

  constructor() {
    this.initOpenedStatus();
  }

  private async initOpenedStatus(): Promise<void> {
    this.isOpenedEditModeGuide = true;
  }

  /**
   * 编辑模式引导页打点信息
   *
   * @param GuideReportStatus 打点事件状态
   */
  public editModeGuideReport(status: GuideReportStatus): void {
    let params: ReportParams = {
      PNAMEID: PNAMEID,
      PVERSIONID: PVERSIONID,
      EDIT_MODE_GUIDE_STATUS: status
    };
    this.mOuterHomeReportEvent.reportBehavior(LAUNCHER_EDIT_MODE_GUIDE_EVENT, params);
  }

  /**
   * 判断是否需要提示页的场景
   *
   * @returns boolean true需要提示页，false不需要
   */
  public isNeedOpenGuidePage(): boolean {
    if (this.isOpenedEditModeGuide) {
      return false;
    }
    let isInEditMode = editModeManager.isInEditMode();
    return false;
  }

  /**
   * 通过滑动打开编辑模式操作提示页面
   * 首次在外屏尾页滑动时需显示提示页
   *
   * @param index,targetIndex,extraInfo Swiper组件onAnimationStart三个参数
   * @param pageLength 桌面数量
   */
  public openEditModeGuideBySwipe(index: number, targetIndex: number, extraInfo: SwiperAnimationEvent,
    pageLength: number): void {
    let isLastPage = index === targetIndex && index === pageLength - 1;
    // 镜像尾页向左划,正常模式尾页向右划
    let isSwipeEnd = RTLUtil.isRTL() ? extraInfo.currentOffset > 0 : extraInfo.currentOffset < 0;
    if (this.isNeedOpenGuidePage() && isLastPage && isSwipeEnd) {
      log.showInfo('open edit mode guide by swipe');
      AppStorage.setOrCreate('isShowEditModeGuidePage', true);
      this.editModeGuideReport(GuideReportStatus.OPEN_BY_SWIPE);
    }
  }

  /**
   * 通过长按屏幕打开编辑模式操作提示页面
   */
  public openEditModeGuideByLongClick(): void {
    if (this.isNeedOpenGuidePage()) {
      log.showInfo('open edit mode guide by longClick');
      AppStorage.setOrCreate('isShowEditModeGuidePage', true);
      this.editModeGuideReport(GuideReportStatus.OPEN_BY_LONG_CLICK);
    }
  }

  /**
   * 储存引导页显示过的状态
   */
  public saveOpenedStatus(): void {
    let preferenceStore: PreferenceStore =
      new PreferenceStore(getContext()?.getApplicationContext() || GlobalContext.getContext(), 'DesktopSetting');
    preferenceStore.put(GUIDE_PREFERENCE_KEY, true, true);
    this.isOpenedEditModeGuide = true;
  }

  /**
   * 获取提示帧动画资源
   */
  public getFlashlightTipsResource(): ImageFrameInfo[] {
    let images: ImageFrameInfo[] = [];
    let fileNames: string[] = FileUtils.getFileList(RESOURCE_PATH);
    let lastIndex = fileNames.length - 1;
    for (let i = 0; i < fileNames.length; i++) {
      let imagePath = fu.getUriFromPath(RESOURCE_PATH + FILE_SEPARATOR + FILE_NAME_PREFIX + i + FILE_NAME_SUFFIX);
      let frameInfo: ImageFrameInfo = {
        src: imagePath,
        duration: i === lastIndex ? ANIMATION_DURATION_END : ANIMATION_DURATION
      }
      images.push(frameInfo);
    }
    return images;
  }
}

export const editModeGuideManager: EditModeGuideManager = SingletonHelper.getInstance(EditModeGuideManager, TAG);