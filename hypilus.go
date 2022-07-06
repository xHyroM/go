package main

import (
	"encoding/json"
	"log"
	"math/rand"
	"net/http"
	"strconv"

	"github.com/gorilla/mux"
)

type Project struct {
	ID          string `json:"id"`
	Name        string `json:"name"`
	Description string `json:"description"`
	DownloadURL string `json:"download_url"`
	JenkinsURL  string `json:"jenkins_url"`
}

// Simple db
var projects []Project

func main() {
	r := mux.NewRouter()

	projects = append(projects, Project{
		ID:          strconv.Itoa(rand.Intn(100000000)),
		Name:        "lol",
		Description: "asd",
		DownloadURL: "pog",
		JenkinsURL:  "lol",
	})

	// Routers
	r.HandleFunc("/api/list", getList).Methods("GET")
	r.HandleFunc("/api/add", addProject).Methods("POST")

	// Start server
	log.Print("Server is running on port :8080 http://localhost:8080")
	log.Fatal(http.ListenAndServe(":8080", r))
}

func getList(writer http.ResponseWriter, req *http.Request) {
	writer.Header().Set("Content-Type", "application/json")
	json.NewEncoder(writer).Encode(projects)
}

func addProject(writer http.ResponseWriter, req *http.Request) {
	writer.Header().Set("Content-Type", "application/json")
	var newProject Project
	json.NewDecoder(req.Body).Decode(&newProject)
	newProject.ID = strconv.Itoa(rand.Intn(100000000))

	if newProject.Description == "" ||
		newProject.DownloadURL == "" ||
		newProject.ID == "" ||
		newProject.JenkinsURL == "" ||
		newProject.Name == "" {
		writer.WriteHeader(http.StatusBadRequest)
		writer.Write([]byte(`{"error": "Missing required fields"}`))
		return
	}

	projects = append(projects, newProject)
	json.NewEncoder(writer).Encode(newProject)
}
