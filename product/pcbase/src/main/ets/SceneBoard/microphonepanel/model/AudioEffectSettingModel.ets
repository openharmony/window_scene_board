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
import audio from '@ohos.multimedia.audio';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { SettingsKeyConstants } from '../common/Constants';
import XmlParseUtil from '../util/XmlParseUtil';
import SettingsUtil from '../../soundpanel/util/SettingsUtil';

const TAG = 'MicrophonePanel-AudioEffectSettingModel';
const log = LogHelper.getLogHelper(LogDomain.SCB, TAG);
/**
 * sound音效功能下发参数：
 * 输出音效：
 * 人声消除/人声提取： class: aiss  prop: 消除 AISSVR /提取 AISSVX /关闭 AISSOFF
 * 通话降噪： class: voip_down  prop: 开启 NRON /关闭 NROFF
 * 输入音效：
 * 静谧空间/纯净人声： class: voip_up  prop: 静谧 PNR /纯净 AINR /关闭 AIHD
 * 录音降噪： class: record  prop: 开启 NRON /关闭 NROFF
**/

enum AudioEffectClass {
  VOICE_CANCEL = 'aiss',
  NOISE_REDUCT = 'voip_down'
}

export enum AudioEffectProp {
  EFFECT_EXTRACT = 'AISSVX',
  EFFECT_CANCEL = 'AISSVR',
  EFFECT_DEFAULT = 'AISSOFF',
  NOISE_REDUCT_ON = 'NRON',
  NOISE_REDUCT_OFF = 'NROFF'
}

enum AudioEnhanceClass {
  CALL_REINFORCE = 'voip_up',
  NOISE_REDUCT = 'record'
}

export enum AudioEnhanceProp {
  ENHANCE_DEFAULT = 'AIHD',
  ENHANCE_MULTIPLE = 'AINR',
  ENHANCE_SINGLE = 'PNR',
  NOISE_REDUCT_ON = 'NRON',
  NOISE_REDUCT_OFF = 'NROFF'
}

export interface voiceCancelStatusChangeListener { onVoiceCancelStatusChange: ( category: string ) => void };
export interface effectNoiseReductStatusChangeListener {
  onEffectNoiseReductStatusChange: ( category: string ) => void
};
export interface callReinforceStatusChangeListener { onCallReinforceStatusChange: ( category: string ) => void };
export interface enhanceNoiseReductStatusChangeListener {
  onEnhanceNoiseReductStatusChange: ( category: string ) => void
};

export class AudioEffectSettingModel {
  private voiceCancelStatusChangeListeners = new Set<voiceCancelStatusChangeListener>();
  private effectNoiseReductStatusChangeListeners = new Set<effectNoiseReductStatusChangeListener>();
  private callReinforceStatusChangeListeners = new Set<callReinforceStatusChangeListener>();
  private enhanceNoiseReductStatusChangeListeners = new Set<enhanceNoiseReductStatusChangeListener>();
  private audioManager: audio.AudioManager = audio.getAudioManager();
  private audioEffectManager: audio.AudioEffectManager | null = null;
  private voiceCancelStatus: string = AudioEffectProp.EFFECT_DEFAULT;
  private effectNoiseReductStatus: string = AudioEffectProp.NOISE_REDUCT_OFF;
  private callReinforceStatus: string = AudioEnhanceProp.ENHANCE_DEFAULT;
  private enhanceNoiseReductStatus: string = AudioEnhanceProp.NOISE_REDUCT_OFF;

  constructor() {
    this.init();
  }

  private async init(): Promise<void> {
    this.initAudioEffectManager();
    this.initSoundAISettingsValue();
    this.registerOutputListener();
    this.registerIntputListener();
  }

  private initAudioEffectManager(): void {
    if (this.audioEffectManager === null) {
      try {
        this.audioEffectManager = this.audioManager.getEffectManager();
      } catch (e) {
        log.showError(`initAudioEffectManager error: ${e?.message}`);
      }
    }
  }

  // 输出 - 更新通过降噪状态和当前声音消除状态
  private updateAudioEffectProperty(): void {
    this.initAudioEffectManager();
    try {
      let effect: Array<audio.AudioEffectProperty> | undefined = this.audioEffectManager?.getAudioEffectProperty();
      effect?.forEach((item: audio.AudioEffectProperty) => {
        log.showInfo(`updateAudioEffectProperty: ${item.name} - ${item.category} - ${item.flag}`);
        if (item.name === AudioEffectClass.VOICE_CANCEL) {
          this.voiceCancelStatus = item.category;
        }
        if (item.name === AudioEffectClass.NOISE_REDUCT) {
          this.effectNoiseReductStatus = item.category;
        }
        if (item.name === AudioEnhanceClass.CALL_REINFORCE) {
          this.callReinforceStatus = item.category;
        }
        if (item.name === AudioEnhanceClass.NOISE_REDUCT) {
          this.enhanceNoiseReductStatus = item.category;
        }
      });
    } catch (e) {
      log.showError(`updateAudioEffectProperty fail: ${e?.message}}`);
    }
  }

  private async refreshVoiceCancel(): Promise<void> {
    let value = await this.getSettingsDataDomainValue(SettingsKeyConstants.SOUND_AI_AISS_SELECT);
    log.info(`SoundAIEffectListener regStatus sound ai type settings is changed：${value}`);
    this.voiceCancelStatus = value;
    this.refreshVoiceCancelStatus(value);
  }

  private async refreshEffectNoiseReduct(): Promise<void> {
    let value = await this.getSettingsDataDomainValue(SettingsKeyConstants.SOUND_AI_VOIP_DOWN_SELECT);
    log.info(`SoundAICallNoiseListener regStatus sound ai type settings is changed：${value}`);
    this.effectNoiseReductStatus = value;
    this.refreshEffectNoiseReductStatus(value);
  };

  private async refreshCallReinforce(): Promise<void> {
    let value = await this.getSettingsDataDomainValue(SettingsKeyConstants.SOUND_AI_VOIP_UP_SELECT);
    log.info(`SoundAIEnhanceListener regStatus sound ai type settings is changed：${value}`);
    this.callReinforceStatus = value;
    this.refreshCallReinforceStatus(value);
  };

  private async refreshEnhanceNoiseReduct(): Promise<void> {
    let value = await this.getSettingsDataDomainValue(SettingsKeyConstants.SOUND_AI_RECORD_SELECT);
    log.info(`SoundAIRecordNoiseListener regStatus sound ai type settings is changed：${value}`);
    this.enhanceNoiseReductStatus = value;
    this.refreshEnhanceNoiseReductStatus(value);
  };

  private async initSoundAISettingsValue(): Promise<void> {
    this.updateAudioEffectProperty();
    this.refreshEffectNoiseReduct();
    this.refreshEnhanceNoiseReduct();
  }

  private async getSettingsDataDomainValue(key: string): Promise<string> {
    return await SettingsUtil.getSystemValue(key, '');
  }

  private refreshVoiceCancelStatus(category: string): void {
    this.voiceCancelStatusChangeListeners.forEach(listener => {
      listener.onVoiceCancelStatusChange(category);
    });
  }

  private refreshEffectNoiseReductStatus(category: string): void {
    this.effectNoiseReductStatusChangeListeners.forEach(listener => {
      listener.onEffectNoiseReductStatusChange(category);
    });
  }

  private refreshCallReinforceStatus(category: string): void {
    this.callReinforceStatusChangeListeners.forEach(listener => {
      listener.onCallReinforceStatusChange(category);
    });
  }

  private refreshEnhanceNoiseReductStatus(category: string): void {
    this.enhanceNoiseReductStatusChangeListeners.forEach(listener => {
      listener.onEnhanceNoiseReductStatusChange(category);
    });
  }

  /**
   * 订阅settings输出面板状态
   */
  private registerOutputListener(): void {
    if (XmlParseUtil.getCallNoiseReductforceSupport()) {
      try {
        SettingsUtil.registerKeyObserverSystem(SettingsKeyConstants.SOUND_AI_VOIP_DOWN_SELECT, () => {
            log.info('SoundAICallNoiseListener regStatus listen change');
            this.refreshEffectNoiseReduct();
          });
      } catch (e) {
        log.error(`SoundAICallNoiseListener regStatus fail ${e?.message}`);
      }
    }
    if (XmlParseUtil.getVocalCancelSupport()) {
      try {
        SettingsUtil.registerKeyObserverSystem(SettingsKeyConstants.SOUND_AI_AISS_SELECT, () => {
            log.info('SoundAIEffectListener regStatus listen change');
            this.refreshVoiceCancel();
          });
      } catch (e) {
        log.error(`SoundAIEffectListener regStatus fail ${e?.message}`);
      }
    }
  }

  /**
   * 订阅settings输入面板状态
   */
  private registerIntputListener(): void {
    if (XmlParseUtil.getRecordNoiseReductforceSupport()) {
      try {
        SettingsUtil.registerKeyObserverSystem(SettingsKeyConstants.SOUND_AI_RECORD_SELECT, () => {
            log.info('SoundAIRecordNoiseListener regStatus listen change');
            this.refreshEnhanceNoiseReduct();
          });
      } catch (e) {
        log.error(`SoundAIRecordNoiseListener regStatus fail ${e?.message}`);
      }
    }
    if (XmlParseUtil.getCallReinforceSupport()) {
      try {
        SettingsUtil.registerKeyObserverSystem(SettingsKeyConstants.SOUND_AI_VOIP_UP_SELECT, () => {
            log.info('SoundAIEnhanceListener regStatus listen change');
            this.refreshCallReinforce();
          });
      } catch (e) {
        log.error(`SoundAIEnhanceListener regStatus fail ${e?.message}`);
      }
    }
  }

  /**
   * 订阅声音消除状态
   *
   * @param listener 监听方法
   */
  public registerVoiceCancelStatusChangeListener(listener: voiceCancelStatusChangeListener): void {
    if (!listener) {
      return;
    }
    this.voiceCancelStatusChangeListeners.add(listener);
    log.showInfo(`register VoiceCancelStatusChangeListener size: ${this.voiceCancelStatusChangeListeners.size}`);
  }

  /**
   * 取消订阅声音消除状态
   *
   * @param listener 监听方法
   */
  public unregisterVoiceCancelStatusChangeListener(listener: voiceCancelStatusChangeListener): void {
    if (!listener) {
      return;
    }
    this.voiceCancelStatusChangeListeners.delete(listener);
    log.showInfo(`unregister VoiceCancelStatusChangeListener size: ${this.voiceCancelStatusChangeListeners.size}`);
  }

  /**
   * 订阅通话对端降噪状态
   *
   * @param listener 监听方法
   */
  public registerEffectNoiseReductStatusChangeListener(listener: effectNoiseReductStatusChangeListener): void {
    if (!listener) {
      return;
    }
    this.effectNoiseReductStatusChangeListeners.add(listener);
    log.showInfo(`register EffectNoiseReductStatusChangeListener size: ${this.effectNoiseReductStatusChangeListeners.size}`);
  }

  /**
   * 取消订阅通话对端降噪状态
   *
   * @param listener 监听方法
   */
  public unregisterEffectNoiseReductStatusChangeListener(listener: effectNoiseReductStatusChangeListener): void {
    if (!listener) {
      return;
    }
    this.effectNoiseReductStatusChangeListeners.delete(listener);
    log.showInfo(`unregister EffectNoiseReductStatusChangeListener size: ${this.effectNoiseReductStatusChangeListeners.size}`);
  }

  /**
   * 订阅通话增强状态
   *
   * @param listener 监听方法
   */
  public registerCallReinforceStatusChangeListener(listener: callReinforceStatusChangeListener): void {
    if (!listener) {
      return;
    }
    this.callReinforceStatusChangeListeners.add(listener);
    log.showInfo(`register CallReinforceStatusChangeListener size: ${this.callReinforceStatusChangeListeners.size}`);
  }

  /**
   * 取消订阅通话增强状态
   *
   * @param listener 监听方法
   */
  public unregisterCallReinforceStatusChangeListener(listener: callReinforceStatusChangeListener): void {
    if (!listener) {
      return;
    }
    this.callReinforceStatusChangeListeners.delete(listener);
    log.showInfo(`unregister CallReinforceStatusChangeListener size: ${this.callReinforceStatusChangeListeners.size}`);
  }

  /**
   * 订阅录音降噪状态
   *
   * @param listener 监听方法
   */
  public registerEnhanceNoiseReductStatusChangeListener(listener: enhanceNoiseReductStatusChangeListener): void {
    if (!listener) {
      return;
    }
    this.enhanceNoiseReductStatusChangeListeners.add(listener);
    log.showInfo(`register EnhanceNoiseReductStatusChangeListener size: ${this.enhanceNoiseReductStatusChangeListeners.size}`);
  }

  /**
   * 取消订阅录音降噪状态
   *
   * @param listener 监听方法
   */
  public unregisterEnhanceNoiseReductStatusChangeListener(listener: enhanceNoiseReductStatusChangeListener): void {
    if (!listener) {
      return;
    }
    this.enhanceNoiseReductStatusChangeListeners.delete(listener);
    log.showInfo(`unregister EnhanceNoiseReductStatusChangeListener size: ${this.enhanceNoiseReductStatusChangeListeners.size}`);
  }

  /**
   * 获取当前声音消除状态
   */
  public getVoiceCancelStatus(): string {
    return this.voiceCancelStatus;
  }

  /**
   * 获取当前通话降噪状态
   */
  public getEffectNoiseReductStatus(): string {
    return this.effectNoiseReductStatus;
  }

  /**
   * 获取当前通话增强状态
   */
  public getCallReinforceStatus(): string {
    return this.callReinforceStatus;
  }

  /**
   * 获取当前录音降噪状态
   */
  public getEnhanceNoiseReductStatus(): string {
    return this.enhanceNoiseReductStatus;
  }

  /**
   * 下发声音消除状态
   */
  public async setVoiceCancelStatus(status: AudioEffectProp): Promise<boolean> {
    if (status === AudioEffectProp.NOISE_REDUCT_ON || status === AudioEffectProp.NOISE_REDUCT_OFF) {
      log.showError(`error parameters: ${status}`);
      return false;
    }
    if (!await SettingsUtil.setSystemValue(SettingsKeyConstants.SOUND_AI_AISS_SELECT, status)) {
      log.showError(`do set settings VoiceCancelStatus ${status} fail`);
    }
    try {
      this.initAudioEffectManager();
      log.showInfo(`do setVoiceCancelStatus ${status}`);
      this.audioEffectManager?.setAudioEffectProperty([
        {
          name: AudioEffectClass.VOICE_CANCEL,
          category: status,
          flag: 0
        }
      ]);
      this.voiceCancelStatus = status;
    } catch (e) {
      log.showError(`do setVoiceCancelStatus fail ${e?.message}`);
      return false;
    }
    return true;
  }

  /**
   * 下发通话降噪状态
   */
  public async setEffectNoiseReductStatus(status: AudioEffectProp): Promise<boolean> {
    if (status === AudioEffectProp.EFFECT_EXTRACT ||
      status === AudioEffectProp.EFFECT_CANCEL ||
      status === AudioEffectProp.EFFECT_DEFAULT) {
      log.showError(`error parameters: ${status}`);
      return false;
    }
    if (!await SettingsUtil.setSystemValue(SettingsKeyConstants.SOUND_AI_VOIP_DOWN_SELECT, status)) {
      log.showError(`do set settings EffectNoiseReductStatus ${status} fail`);
    }
    try {
      this.initAudioEffectManager();
      log.showInfo(`do setEffectNoiseReductStatus ${status}`);
      this.audioEffectManager?.setAudioEffectProperty([
        {
          name: AudioEffectClass.NOISE_REDUCT,
          category: status,
          flag: 0
        }
      ]);
      this.effectNoiseReductStatus = status;
    } catch (e) {
      log.showError(`do setEffectNoiseReductStatus fail ${e?.message}`);
      return false;
    }
    return true;
  }

  /**
   * 下发通话增强状态
   */
  public async setCallReinforceStatus(status: AudioEnhanceProp): Promise<boolean> {
    if (status === AudioEnhanceProp.NOISE_REDUCT_ON || status === AudioEnhanceProp.NOISE_REDUCT_OFF) {
      log.showError(`error parameters: ${status}`);
      return false;
    }
    if (!await SettingsUtil.setSystemValue(SettingsKeyConstants.SOUND_AI_VOIP_UP_SELECT, status)) {
      log.showError(`do set settings CallReinforceStatus ${status} fail`);
    }
    try {
      this.initAudioEffectManager();
      log.showInfo(`do setCallReinforceStatus ${status}`);
      this.audioEffectManager?.setAudioEffectProperty([
        {
          name: AudioEnhanceClass.CALL_REINFORCE,
          category: status,
          flag: 1
        }
      ]);
      this.callReinforceStatus = status;
    } catch (e) {
      log.showError(`do setCallReinforceStatus fail ${e?.message}`);
      return false;
    }
    return true;
  }

  /**
   * 下发录音降噪状态
   */
  public async setEnhanceNoiseReductStatus(status: AudioEnhanceProp): Promise<boolean> {
    if (status === AudioEnhanceProp.ENHANCE_DEFAULT ||
      status === AudioEnhanceProp.ENHANCE_MULTIPLE ||
      status === AudioEnhanceProp.ENHANCE_SINGLE) {
      log.showError(`error parameters: ${status}`);
      return false;
    }
    if (!await SettingsUtil.setSystemValue(SettingsKeyConstants.SOUND_AI_RECORD_SELECT, status)) {
      log.showError(`do set settings EnhanceNoiseReductStatus ${status} fail`)
    }
    try {
      this.initAudioEffectManager();
      log.showInfo(`do setEnhanceNoiseReductStatus ${status}`);
      this.audioEffectManager?.setAudioEffectProperty([
        {
          name: AudioEnhanceClass.NOISE_REDUCT,
          category: status,
          flag: 1
        }
      ]);
      this.enhanceNoiseReductStatus = status;
    } catch (e) {
      log.showError(`do setEnhanceNoiseReductStatus fail ${e?.message}`);
      return false;
    }
    return true;
  }
}

let audioEffectSettingModel = new AudioEffectSettingModel();

export default audioEffectSettingModel as AudioEffectSettingModel;