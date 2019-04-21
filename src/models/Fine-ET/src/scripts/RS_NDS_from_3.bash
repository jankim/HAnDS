data_directory=../../model_training_data/Fine-ET/RS_NDS_from_3
ckpt_directory=$data_directory/ckpts
dataset_file=../../datasets/sampled_datasets/RS_NDS_from_3.json.gz

mkdir -p $data_directory
mkdir -p $ckpt_directory


# Model parameters
rnn_hidden_neurons=200
keep_prob=0.5
learning_rate=0.002
batch_size=500
char_embedding_size=200
char_rnn_hidden_neurons=50
joint_embedding_size=500
epochs=15   # A number such that approx 19-20 million EMs are used in training
save_checkpoint_after=600000 # Total entities in RS_NDS_from_3: 1290625

# http://nlp.stanford.edu/data/glove.840B.300d.zip
glove_vector_file_path=/hdd1/word_vectors/glove.42B.300d/glove.42B.300d.txt


# Step 1: Generate local variables such as word to number dictionary etc.
#echo "Generate local variables required for model"
#python Fine-ET/src/data_processing/json_to_tfrecord.py prepare_local_variables $dataset_file  $glove_vector_file_path unk $data_directory/ --lowercase

# Step 2: Convert Training data into TFRecord format.
#echo "Converting Train data to TFRecord"
#python Fine-ET/src/data_processing/json_to_tfrecord.py afet_data $data_directory/ $dataset_file

# Step 3: Convert development and testing data into TFRecord format.
#echo "Converting Dev and Test data to TFRecord"
#python Fine-ET/src/data_processing/json_to_tfrecord.py afet_data $data_directory/ ../../datasets/1k-WFB-g/fner_dev.json --test_data
#python Fine-ET/src/data_processing/json_to_tfrecord.py afet_data $data_directory/ ../../datasets/1k-WFB-g/fner_test.json --test_data
#python Fine-ET/src/data_processing/json_to_tfrecord.py afet_data $data_directory/ ../../datasets/figer_gold.json --test_data

# Step 4 (Optional): Convert the development and testing data with entities identified by Fine-ED models to TFRecord format. The following files have to first generated by the Fine-ED model trained on the same dataset. Note that, if the Fine-ED model is retrained, these results file needs to be updated.
#echo "Step 4: Pipeline use of FgED results."
#python Fine-ET/src/detect_entities.py ../../datasets/figer_gold.json ../../results/Fine-ED/lstm_crf/RS_NDS_from_3/figer.conll $data_directory/figer_gold_lstm_crf.json
#python Fine-ET/src/detect_entities.py ../../datasets/1k-WFB-g/fner_dev.json ../../results/Fine-ED/lstm_crf/RS_NDS_from_3/fner_dev.conll $data_directory/fner_dev_lstm_crf.json
#python Fine-ET/src/detect_entities.py ../../datasets/1k-WFB-g/fner_test.json ../../results/Fine-ED/lstm_crf/RS_NDS_from_3/fner_test.conll $data_directory/fner_test_lstm_crf.json
#python Fine-ET/src/data_processing/json_to_tfrecord.py afet_data $data_directory/ $data_directory/fner_dev_lstm_crf.json --test_data
#python Fine-ET/src/data_processing/json_to_tfrecord.py afet_data $data_directory/ $data_directory/fner_test_lstm_crf.json --test_data
#python Fine-ET/src/data_processing/json_to_tfrecord.py afet_data $data_directory/ $data_directory/figer_gold_lstm_crf.json --test_data

# Run train test procedure 5 times
for ((i=1; i<=5; i++)); do
  # Do not emit '_run_' from model ckpt name
  # format: prefix_run_suffix
  model_ckpt_name=checkpoint_run_$i

#  echo "Training a FNET model"
#  time python Fine-ET/src/main_fnet_train.py  $data_directory/ $ckpt_directory/$model_ckpt_name/ 'RS_NDS_from_3.json*.tfrecord' $rnn_hidden_neurons $keep_prob $learning_rate $batch_size $char_embedding_size $char_rnn_hidden_neurons $joint_embedding_size $epochs $save_checkpoint_after --use_mention --use_clean

#  echo "Testing a FNET model on dev data."
#  python Fine-ET/src/main_fnet_test.py $ckpt_directory/$model_ckpt_name/ $data_directory/fner_dev.json_0.tfrecord

#  echo "Testing a FNET model on dev data with entities detected by a Fine-ED model. (Optional)"
#  python Fine-ET/src/main_fnet_test.py $ckpt_directory/$model_ckpt_name/ $data_directory/fner_dev_lstm_crf.json_0.tfrecord

#  echo "Testing a FNET model on test data."
#  python Fine-ET/src/main_fnet_test.py $ckpt_directory/$model_ckpt_name/ $data_directory/fner_test.json_0.tfrecord

#  echo "Testing a FNET model on test data with entities detected by a Fine-ED model. (Optional)"
#  python Fine-ET/src/main_fnet_test.py $ckpt_directory/$model_ckpt_name/ $data_directory/fner_test_lstm_crf.json_0.tfrecord

#  echo "Testing a FNET model on figer gold data."
#  python Fine-ET/src/main_fnet_test.py $ckpt_directory/$model_ckpt_name/ $data_directory/figer_gold.json_0.tfrecord

#  echo "Testing a FNET model on figer data with entities detected by a Fine-ED model. (Optional)"
#  python Fine-ET/src/main_fnet_test.py $ckpt_directory/$model_ckpt_name/ $data_directory/figer_gold_lstm_crf.json_0.tfrecord

  # The final_result file contains the result on the development set based on the strict, macro and micro F1 metrics.
#  echo "Report results FNER dev data."
#  bash Fine-ET/src/scripts/report_result_fnet.bash $ckpt_directory/$model_ckpt_name/fner_dev.json_0.tfrecord/ ../../datasets/1k-WFB-g/fner_dev.json 0 > $ckpt_directory/$model_ckpt_name/fner_dev.json_0.tfrecord/final_result.txt

#  echo "Report results FNER dev data with entities detected by a Fine-ED model. (Optional)"
#  bash Fine-ET/src/scripts/report_result_fnet.bash $ckpt_directory/$model_ckpt_name/fner_dev_lstm_crf.json_0.tfrecord/ ../../datasets/1k-WFB-g/fner_dev.json 0 > $ckpt_directory/$model_ckpt_name/fner_dev_lstm_crf.json_0.tfrecord/final_result.txt

  # The final_result file contains the result on the test set based on the strict, macro and micro F1 metrics.
#  echo "Report results FNER eval data."
#  bash Fine-ET/src/scripts/report_result_fnet.bash $ckpt_directory/$model_ckpt_name/fner_test.json_0.tfrecord/ ../../datasets/1k-WFB-g/fner_test.json 0 > $ckpt_directory/$model_ckpt_name/fner_test.json_0.tfrecord/final_result.txt

#  echo "Report results FNER eval data with entities detected by a Fine-ED model. (Optional)"
#  bash Fine-ET/src/scripts/report_result_fnet.bash $ckpt_directory/$model_ckpt_name/fner_test_lstm_crf.json_0.tfrecord/ ../../datasets/1k-WFB-g/fner_test.json 0 > $ckpt_directory/$model_ckpt_name/fner_test_lstm_crf.json_0.tfrecord/final_result.txt

#  echo "Report results figer data."
#  bash Fine-ET/src/scripts/report_result_fnet.bash $ckpt_directory/$model_ckpt_name/figer_gold.json_0.tfrecord/ ../../datasets/figer_gold.json 0 ../../datasets/label_patch_figer_to_fner.txt > $ckpt_directory/$model_ckpt_name/figer_gold.json_0.tfrecord/final_result.txt

#  echo "Report results figer data with entities detected by a Fine-ED model. (Optional)"
#  bash Fine-ET/src/scripts/report_result_fnet.bash $ckpt_directory/$model_ckpt_name/figer_gold_lstm_crf.json_0.tfrecord/ ../../datasets/figer_gold.json 0 ../../datasets/label_patch_figer_to_fner.txt > $ckpt_directory/$model_ckpt_name/figer_gold_lstm_crf.json_0.tfrecord/final_result.txt
done

