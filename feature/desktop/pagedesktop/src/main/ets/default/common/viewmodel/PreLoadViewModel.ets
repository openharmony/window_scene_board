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

import { DomainName, LogDomain, LogHelper, TraceUtil } from '@ohos/basicutils';
import { LauncherStartup, StartupStep } from '@ohos/launchercommon/src/main/ets/tools/LauncherStartup';
import { BusinessError } from '@kit.BasicServicesKit';
import { settingsDataManager } from '@ohos/frameworkwrapper';
import { PageInfoManager } from '@ohos/launchercommon';
import { PageDesktopViewModel } from './PageDesktopViewModel';

const TAG = 'PreLoadViewModel';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);
const READY_FOR_OOBE_PAGE: number = 2;

/**
 * 单页预加载出错最大尝试次数
 */
const SWIPER_PRELOAD_MAX_TRY_COUNT: number = 10;

/**
 * 单页预加载时间间隔
 */
const SINGLE_PAGE_PRELOAD_TIME_INTERVAL: number = 100;

/**
 * Swiper预加载设置1ms加载间隔，给多模输入事件预留处理时间
 */
const SWIPER_PRELOAD_TIME_INTERVAL: number = 1;

/**
 * 默认的投票个数
 */
const DEFAULT_VOTE_PAGE_COUNT: number = -1;

export class PreLoadConfig {
  private static instance: PreLoadConfig;
  private _votePageCount: number = DEFAULT_VOTE_PAGE_COUNT;

  public set votePageCount(value: number) {
    this._votePageCount = value;
  }

  public get votePageCount(): number {
    return this._votePageCount;
  }

  public static getInstance(): PreLoadConfig {
    if (PreLoadConfig.instance == null) {
      PreLoadConfig.instance = new PreLoadConfig();
    }
    return PreLoadConfig.instance;
  }
}

export class PreLoadViewModel {
  private swiperController: SwiperController;
  private totalPageCount: number = 0;
  private isAlreadyVoteBoot: boolean = false;

  constructor(swiperController: SwiperController, totalPageCount: number) {
    this.totalPageCount = totalPageCount;
    this.swiperController = swiperController;
  }

  public preloadNextPage(preloadPageIndex: number): void {
    if (preloadPageIndex >= this.totalPageCount) {
      LauncherStartup.getInstance().passStep(StartupStep.PRELOAD_FINISHED);
      // 预加载完后执行投票
      this.startVoteBootEvent();
      return;
    }
    if (PreLoadConfig.getInstance().votePageCount !== DEFAULT_VOTE_PAGE_COUNT &&
      preloadPageIndex >= PreLoadConfig.getInstance().votePageCount) {
      this.startVoteBootEvent();
    }
    if (preloadPageIndex < 0) {
      log.showInfo(`End to preload swiperPage as the preloadPage is ${preloadPageIndex}`);
      return;
    }

    TraceUtil.startAnimTrace(DomainName.HOME, TraceUtil.PRELOAD_SWIPER_PAGE_CALLBACK);
    this.swiperPreloadItems(preloadPageIndex);
    TraceUtil.endAnimTrace(DomainName.HOME, TraceUtil.PRELOAD_SWIPER_PAGE_CALLBACK);
  }

  private startVoteBootEvent(): void {
    if (!this.isAlreadyVoteBoot) {
      TraceUtil.startTrace(DomainName.SCB, 'SCBDesktopVoteBoot');
      PageDesktopViewModel.getInstance().voteBootEvent('GridSwiperPreloadFinished');
      TraceUtil.endTrace(DomainName.SCB, 'SCBDesktopVoteBoot');
      this.isAlreadyVoteBoot = true;
    }
  }

  /**
   * 调用swiper page的preloadItems接口
   * @param pages 传入page
   * @param tryCount 重试次数
   */
  private swiperPreloadItems(preloadPageIndex: number, tryCount: number = 0): void {
    if (tryCount > SWIPER_PRELOAD_MAX_TRY_COUNT) {
      log.showError('preloadNextPage[%{public}d] failed', preloadPageIndex);
      this.preloadNextPage(PageInfoManager.getInstance().getNextPreload());
      return;
    }
    log.showInfo(`preloadNextPage begin preloadPageIndex: ${preloadPageIndex}, tryCount: ${tryCount}`);
    /*this.swiperController?.preloadItems([preloadPageIndex], (err: BusinessError) => {
      // 如果预加载失败，间隔100ms后再次预加载该页
      if (err.code) {
        log.showError('preloadNextPage failed, invalid input parameters[%{public}d]. error %{public}d:%{public}s',
          preloadPageIndex, err.code, err.message);
        setTimeout(() => {
          this.swiperPreloadItems(preloadPageIndex, tryCount + 1);
        }, SINGLE_PAGE_PRELOAD_TIME_INTERVAL);
        return;
      }
      log.showInfo(`preloadNextPage preload done, page: ${preloadPageIndex}`);
      // 预加载成功，加载下一页，Swiper预加载设置1ms加载间隔，给多模输入事件预留处理时间
      setTimeout(() => {
        this.preloadNextPage(PageInfoManager.getInstance().getNextPreload());
      }, SWIPER_PRELOAD_TIME_INTERVAL);
      if (preloadPageIndex === READY_FOR_OOBE_PAGE) {
        settingsDataManager.setValue(null, 'isFirstPageLoaded', 'true');
      }
    });*/
  }
}