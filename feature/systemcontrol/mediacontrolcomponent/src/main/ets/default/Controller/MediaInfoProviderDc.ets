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

import { LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/utils/LogHelper';
import { messageChannel } from '@ohos/systemuicommon/src/main/ets/messageChannel/MessageChannel';
import inputConsumer from '@ohos.multimodalInput.inputConsumer';
import Constants, { AVQueueInfo, SetVolumeType, InputVolumeAction } from '../Util/Constants';

const TAG = 'MediaInfoProviderDc';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.MC, TAG);

export class MediaInfoProviderDc {
  private static provider: MediaInfoProviderDc | undefined = undefined;
  public inputMediaVolumeCallback: (callback: inputConsumer.KeyOptions) => void = () => {};
  public inputCallVolumeCallback: (callback: inputConsumer.KeyOptions) => void = () => {};

  public static getInstance(): MediaInfoProviderDc {
    if (!MediaInfoProviderDc.provider) {
      MediaInfoProviderDc.provider = new MediaInfoProviderDc();
    }
    return MediaInfoProviderDc.provider;
  }

  /**
   * 读取历史歌单
   */
  getHistoryFromAVSession() {
    messageChannel.sendMessage(Constants.ASYNC_MEDIA_INFO_PROVIDER, {type: 'getHistoryFromAVSession'});
  }

  /**
   * 读取媒体信息
   */
  getMetadataFromAVSession() {
    messageChannel.sendMessage(Constants.ASYNC_MEDIA_INFO_PROVIDER, {type: 'getMetadataFromAVSession'});
  }

  /**
   * 监听castSession
   * @param hasCast 是否存在castSession双卡（本地与投播卡片）
   * @param sessionId
   */
  setCastSessionListener(hasCast: boolean, sessionId: string | undefined) {
    messageChannel.sendMessage(Constants.ASYNC_MEDIA_INFO_PROVIDER, {
      type: 'getMetadataFromAVSession', hasCast, sessionId
    });
  }

  /**
   * 清除castSession监听
   */
  clearCastSessionListener() {
    messageChannel.sendMessage(Constants.ASYNC_MEDIA_INFO_PROVIDER, {type: 'clearCastSessionListener'});
  }

  /**
   * 是否为视频session
   * @param sessionId
   * @returns
   */
  getIsVideo(sessionId: string): Object {
    return messageChannel.callObject(Constants.MEDIA_INFO_PROVIDER, 'getIsVideo', sessionId);
  }

  /**
   * 启动歌单
   * @param albInfo
   * @param albumInfoListData
   */
  startAlbum(albInfo: AVQueueInfo, albumInfoListData: AVQueueInfo[]) {
    messageChannel.sendMessage(Constants.ASYNC_MEDIA_INFO_PROVIDER, {
      type: 'startAlbum', avQueueId: albInfo.avQueueId,
    });
  }

  /**
   * 启动歌单（折叠屏展开态）
   * @param albInfo
   * @param albumInfoListData
   */
  startExpandAlbum(albInfo: AVQueueInfo, albumInfoListData: AVQueueInfo[]) {
    messageChannel.sendMessage(Constants.ASYNC_MEDIA_INFO_PROVIDER, {
      type: 'startExpandAlbum', avQueueId: albInfo.avQueueId,
    });
  }

  /**
   * 上报设备日志
   * @param sessionId
   * @param startTime
   * @param isShowSwitch
   */
  reportShowDeviceList(sessionId: string, startTime: number, isShowSwitch: number) {
    messageChannel.sendMessage(Constants.ASYNC_MEDIA_INFO_PROVIDER, {
      type: 'reportShowDeviceList', sessionId, startTime, isShowSwitch,
    });
  }

  /**
   * 上报播放状态
   * @param albInfo
   * @param timeCost
   */
  reportStartMediaPlayBack(albInfo: AVQueueInfo, timeCost: number) {
    messageChannel.sendMessage(Constants.ASYNC_MEDIA_INFO_PROVIDER, {
      type: 'reportStartMediaPlayBack', avQueueId: albInfo.avQueueId, timeCost,
    });
  }

  /**
   * 拉起应用
   * @param sessionId
   */
  startAimApp(sessionId: string) {
    messageChannel.sendMessage(Constants.ASYNC_MEDIA_INFO_PROVIDER, {type: 'startAimApp', sessionId});
  }

  /**
   * 清除歌单
   */
  deleteAlbumInfoListLink() {
    messageChannel.sendMessage(Constants.ASYNC_MEDIA_INFO_PROVIDER, {type: 'deleteAlbumInfoListLink'});
  }

  /**
   * 是否为投播session
   * @param sessionId
   */
  checkIsSinkSession(sessionId: string): Object {
    return messageChannel.callObject(Constants.MEDIA_INFO_PROVIDER, 'checkIsSinkSession', sessionId);
  }

  /**
   * 是否为投播session
   * @param sessionId
   */
  checkIsCastSession(sessionId: string): boolean {
    return messageChannel.callObject(Constants.MEDIA_INFO_PROVIDER, 'checkIsCastSession', sessionId) as boolean;
  }

  /**
   * 刷新音量
   * @param sessionId
   */
  refreshVolume(sessionId: string) {
    messageChannel.sendMessage(Constants.ASYNC_MEDIA_INFO_PROVIDER, {type: 'refreshVolume', sessionId});
  }

  /**
   * 快退
   * @param parameter
   */
  callRewind(sessionId: string, movePosition: number) {
    messageChannel.sendMessage(Constants.ASYNC_MEDIA_INFO_PROVIDER, {type: 'rewind', sessionId, movePosition});
  }

  /**
   * 快进
   * @param sessionId
   * @param movePosition
   */
  callForward(sessionId: string, movePosition: number) {
    messageChannel.sendMessage(Constants.ASYNC_MEDIA_INFO_PROVIDER, {type: 'fastForward', sessionId, movePosition});
  }

  /**
   * 收藏
   * @param sessionId
   * @param isFavorite
   */
  callFavorites(sessionId: string, isFavorite: boolean) {
    messageChannel.sendMessage(Constants.ASYNC_MEDIA_INFO_PROVIDER, {type: 'favor', sessionId, isFavorite});
  }

  /**
   * 上一首
   * @param sessionId
   */
  callPrevious(sessionId: string) {
    messageChannel.sendMessage(Constants.ASYNC_MEDIA_INFO_PROVIDER, {type: 'previous', sessionId});
  }

  /**
   * 下一首
   * @param sessionId
   */
  callNext(sessionId: string) {
    messageChannel.sendMessage(Constants.ASYNC_MEDIA_INFO_PROVIDER, {type: 'next', sessionId});
  }

  /**
   * 播放
   * @param sessionId
   */
  callPlay(sessionId: string, isColdStart: boolean, isForceTopSession: boolean = false) {
    messageChannel.sendMessage(Constants.ASYNC_MEDIA_INFO_PROVIDER,
      {type: 'play', sessionId, isColdStart, isForceTopSession});
  }

  /**
   * 暂停
   * @param sessionId
   */
  callPause(sessionId: string) {
    messageChannel.sendMessage(Constants.ASYNC_MEDIA_INFO_PROVIDER, {type: 'pause', sessionId});
  }

  /**
   * 冷启动
   * @param sessionId
   * @param isFromSessionCreate
   * @param shouldCallPlay
   */
  startDefaultAppNow(sessionId: string, isFromSessionCreate: boolean, shouldCallPlay: boolean) {
    messageChannel.sendMessage(Constants.ASYNC_MEDIA_INFO_PROVIDER, {
      type: 'startDefaultAppNow', sessionId, isFromSessionCreate, shouldCallPlay,
    });
  }

  /**
   * 进度跳转
   * @param sessionId
   * @param time
   */
  callSeek(sessionId: string, time: number) {
    messageChannel.sendMessage(Constants.ASYNC_MEDIA_INFO_PROVIDER, {type: 'seek', sessionId, time});
  }

  /**
   * 循环模式
   * @param sessionId
   * @param time
   */
  callLoop(sessionId: string, loopMode: number) {
    messageChannel.sendMessage(Constants.ASYNC_MEDIA_INFO_PROVIDER, {type: 'loopMode', sessionId, loopMode});
  }

  /**
   * 调节音量
   * @param volume
   * @param mode
   * @param sessionId
   */
  callVolumeChange(volume: number, mode: number, sessionId?: string) {
    messageChannel.sendMessage(Constants.ASYNC_MEDIA_INFO_PROVIDER, {
      type: 'callVolumeChange', sessionId, volume, mode,
    });
  }

  /**
   * 调节音量（物理按键）
   * @param type
   * @param inputType
   * @param sessionId
   */
  callVolumeInput(volumeType: SetVolumeType, actionType: InputVolumeAction, sessionId?: string) {
    messageChannel.sendMessage(Constants.ASYNC_MEDIA_INFO_PROVIDER, {
      type: 'callVolumeInput', sessionId, volumeType, actionType,
    });
  }

  /**
   * 调节对端音量
   * @param sessionId
   * @param actionType
   */
  callCastVolumeChange(sessionId: string, actionType: InputVolumeAction) {
    messageChannel.sendMessage(Constants.ASYNC_MEDIA_INFO_PROVIDER, {
      type: 'callCastVolumeChange', sessionId, actionType,
    });
  }

  /**
   * 播放歌单
   * @param albInfo
   * @param oldAlbInfo
   */
  replayAlbum(albInfo: AVQueueInfo, oldAlbInfo: AVQueueInfo) {
    messageChannel.sendMessage(Constants.ASYNC_MEDIA_INFO_PROVIDER, {
      type: 'replayAlbum', avQueueId: albInfo?.avQueueId, oldAvQueueId: oldAlbInfo?.avQueueId,
    });
  }

  playAvQueue(bundleName: string, avQueueId: string) {
    messageChannel.sendMessage(Constants.ASYNC_MEDIA_INFO_PROVIDER, {
      type: 'playAvQueue', bundleName: bundleName, avQueueId: avQueueId
    });
  }

  getHistoricalAndRecommendData() {
    messageChannel.sendMessage(Constants.ASYNC_MEDIA_INFO_PROVIDER, {
      type: 'getHistoricalAndRecommendData'
    });
  }

  isExistAvQueueStateUpdate() {
    messageChannel.sendMessage(Constants.ASYNC_MEDIA_INFO_PROVIDER, {
      type: 'isExistAvQueueStateUpdate'
    });
  }

  /**
   * 读取歌单
   */
  getHistoricalOrRecommendData() {
    messageChannel.sendMessage(Constants.ASYNC_MEDIA_INFO_PROVIDER, {
      type: 'getHistoricalOrRecommendData',
      showRecommend: false,
    });
  }

  /**
   * 歌单显示上报
   * @param showState
   * @param operatingMode
   * @param isHistoryAVQueue
   */
  reportAVQueueShowState(showState: number, operatingMode: number, isHistoryAVQueue: boolean) {
    messageChannel.sendMessage(Constants.ASYNC_MEDIA_INFO_PROVIDER, {
      type: 'reportAVQueueShowState', showState, operatingMode, isHistoryAVQueue,
    });
  }

  isJumpFromList(sessionId: string): Object {
    return messageChannel.callObject(Constants.MEDIA_INFO_PROVIDER, 'isJumpFromList', sessionId);
  }

  releaseInputMediaVolumeCallback() {
    messageChannel.sendMessage(Constants.ASYNC_MEDIA_INFO_PROVIDER, {
      type: 'releaseInputMediaVolumeCallback',
    });
  }
}